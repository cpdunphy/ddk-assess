//
//  TimerSession.swift
//  Diadochokinetic Assess
//
//  Created by Collin on 12/1/19.
//  Copyright © 2019 Ballygorey Apps. All rights reserved.
//

import Combine
import Foundation
import SwiftUI
import CoreHaptics

class TimerSession: ObservableObject {
    
    //MARK: Variables
    
    //Overarching
    @Published var recordingsArr: [Record] = []
    private var timerCountingDown = Timer()
    private var timerCountingUp = Timer()
    @Published var timedTaps: Int = 0
    @Published var unTimedTaps: Int = 0
    @Published var logCount = defaults.integer(forKey: userLogCountKey)
    @Published var totalLogCount = defaults.integer(forKey: userLogCountLifetimeKey)
    ///Time left on the Timer + Countdown
    @Published var currentTimedCount: Double = 10.0
    @Published var countdownCount = UserDefaults.standard.double(forKey: countdownKey) + 0.9
    @Published var currentUntimedCount = 0

    ///Timer CountingState
    @Published var countingState: PossibleCountingStates = .ready
    
    ///Used to calculate percent of the ring to be filled
    @Published var percent: Double = 1.0
    var totalTimerDuration: TimeInterval = 10

    @Published var showHeartRate: Bool = defaults.bool(forKey: heartRateKey)
    
//    @Published var showSupportAd : Bool = false
//    @Published var showReviewAd: Bool = false
    @Published var showCentralAlert: Bool = false
    @Published var activeAlert: ActiveAlert = .none
    
    //MARK: Both Categories
    private var timeInterval = 1.0/3.0 ///Time between each timer "TimerDidFire"
    
    @objc func timerDidFireDown() {
        if currentTimedCount > 0.0 && countingState == .counting {
            currentTimedCount -= timeInterval
            if currentTimedCount <= 1.0 {
                FinishTimedMode()
            }
        } else if countdownCount > 0.0 && countingState == .countdown {
            countdownCount -= timeInterval
            if countdownCount < 1.0 {
                countingState = .counting
            }
        }
//        withAnimation(.easeIn) {
            percent = (currentTimedCount-0.9)/Double(totalTimerDuration)
//        }
        print("\(countingState)")
    }
    
    func addTimedTaps() {
        timedTaps += 1
    }
    
    func increaseLogCount() {
        logCount += 1 + addNumberToLogFromIAP
        if addNumberToLogFromIAP != 0 {
            addNumberToLogFromIAP = 0
        }
        totalLogCount += 1
        saveLogs()
        checkShowSupport()
    }
    
    ///@ 30 logs, asks for review, @ 60 asks for donation
    ///Testing @5 logs, asks for review, @ 10 asks for donation
    func setLogCount(num: Int) {
        defaults.set(num, forKey: userLogCountKey)
        logCount = defaults.integer(forKey: userLogCountKey)
    }
    func saveLogs() {
        defaults.set(logCount, forKey: userLogCountKey)
        defaults.set(totalLogCount, forKey: userLogCountLifetimeKey)
    }
    func checkShowSupport() {
        let showReview: Bool = logCount == 30
        let showDonation: Bool = logCount == 60
        
        if showReview {
            activeAlert = .review
            showCentralAlert = true
        } else if showDonation {
            activeAlert = .buying
            showCentralAlert = true
        } else {
            activeAlert = .none
        }
    }
    
    //MARK: Timed Functions
    func startCountdown(time: Int) {
        timerCountingDown = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(timerDidFireDown), userInfo: nil, repeats: true)
        currentTimedCount = Double(time) + 0.9
        totalTimerDuration = Double(time)
        countdownCount = defaults.double(forKey: countdownKey) + 0.9
        if countdownCount > 1.0 {
            countingState = .countdown
        } else {
            countingState = .counting
        }
        print("Timer started!")
    }
    
    func PauseTimedMode() {
        countingState = .paused
        print("Timer paused!")
    }
    
    func ResumeTimedMode() {
        countingState = countdownCount > 0.0 ? .countdown : .counting
        print("Timer resumed!")
    }
    
    func ResetTimedMode() {
        countingState = .ready
        timerCountingDown.invalidate()
        currentTimedCount = 10.0
        percent = 1.0
        timedTaps = 0
        print("Timer reset!")
    }
    

    private func FinishTimedMode() {
        timerCountingDown.invalidate()
        let send = Record(date: Date(), taps: timedTaps, timed: true, duration: Int(totalTimerDuration))
        increaseLogCount()
        self.recordingsArr.insert(send, at: 0)
        countingState = .finished
        hapticFeedback.notificationOccurred(.success)
    }
    
    func getTimeRemaining() -> String {
        let intTimeCount = Int(currentTimedCount)
        if intTimeCount == 60 {
            return "01:00"
        } else if  intTimeCount >= 10{
            return "00:\(intTimeCount)"
        } else {
            return "00:0\(intTimeCount)"
        }
    }
    
    /// Calculates and returns the beats per minute in timed mode.
    ///
    /// - Parameter value: Duration = how long we are looking to average. Taps = how many occurances.
    /// - Returns: Beats per minute (Int)
    func CalculateBPM(taps: Int, duration: TimeInterval) -> Int {
        let numToComplete = 60/duration
        let bpm = Double(taps) * numToComplete
        return Int(bpm)
    }
    
    //MARK: Untimed Functions
    
    func finishAndLogUntimed() {
        logUntimed()
        stopUntimed()
    }
    
    func stopUntimed() {
        timerCountingUp.invalidate()
        unTimedTaps = 0
        currentUntimedCount = 0

    }
    private func logUntimed() {
        let send = Record(date: Date(), taps: unTimedTaps, timed: false, duration: Int(currentUntimedCount))
        increaseLogCount()
        self.recordingsArr.insert(send, at: 0)
        hapticFeedback.notificationOccurred(.success)
    }
    
    func addUntimedTaps() {
        unTimedTaps += 1
    }
    
    private func startUntimed() {
        timerCountingUp = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerDidFireUp), userInfo: nil, repeats: true)
    }
    
    @objc func timerDidFireUp() {
        currentUntimedCount += 1
    }
    
    /// Time (String) in "00:00 format"
    ///
    /// - Parameter value: seconds (Int)
    /// - Returns: String to be displayed for standard "00:00 Display"
    func getStandardTimeDisplayString(seconds: Int) -> String {
        if seconds < 10 {
            return "00:0\(seconds)"
        } else if seconds >= 10 && seconds < 60 {
            return "00:\(seconds)"
        } else if seconds >= 60 && seconds < 600 {
            if seconds%60 < 10 {
                return "0\(seconds/60):0\(seconds%60)"
            }
            return "0\(seconds/60):\(seconds%60)"
        } else {
            if seconds%60 < 10 {
                return "\(seconds/60):0\(seconds%60)"
            }
            return "\(seconds/60):\(seconds%60)"
        }
    }
    
    /// Fires at first tap of Untimed Mode
    ///
    /// - Parameter value: None
    /// - Returns: Void
    
    func firstTap() {
        print("First Tap of Count Mode")
        startUntimed()
    }
}
//100000000000/60/60/24/365

extension TimerSession {
    func grabUserData() {
        logCount = defaults.integer(forKey: userLogCountKey)
    }
}
