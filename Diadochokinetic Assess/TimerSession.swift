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

class TimerSession: ObservableObject {
    
    //MARK: Variables
    
    //Overarching
    @Published var recordingsArr: [Record] = []
    private var timerCountingDown = Timer()
    private var timerCountingUp = Timer()
    @Published var timedTaps: Int = 0
    @Published var unTimedTaps: Int = 0
    @Published var logCount = defaults.integer(forKey: userLogCountKey)
    
    ///Time left on the Timer + Countdown
    @Published var currentTimedCount: Double = 10.0
    @Published var countdownCount = UserDefaults.standard.double(forKey: countdownKey) + 0.9
    @Published var currentUntimedCount = 0

    
    ///Timer CountingState
    @Published var countingState: PossibleCountingStates = .ready
    
    ///Used to calculate percent of the ring to be filled
    @Published var percent: Double = 1.0
    private var totalTimerDuration: Double = 10.0

    @Published var showHeartRate: Bool = defaults.bool(forKey: heartRateKey)
    
    @Published var showSupportAd : Bool = false
    
    //MARK: Both Categories
    private var timeInterval = 1.0/3.0
    
    @objc func timerDidFireDown() {
        if currentTimedCount > 0.0 && countingState == .counting {
            currentTimedCount -= timeInterval
            if currentTimedCount <= 1.0 {
                finishTimed()
            }
        } else if countdownCount > 0.0 && countingState == .countdown {
            countdownCount -= timeInterval
            if countdownCount < 1.0 {
                countingState = .counting
            }
        }
        withAnimation(.easeIn) {
            percent = (currentTimedCount-0.9)/Double(totalTimerDuration)
        }
        print("\(countingState)")
    }
    
    func addTimedTaps() {
        timedTaps += 1
    }
    
    func increaseLogCount() {
            let num = logCount + 1
            let total = defaults.integer(forKey: userLogCountLifetimeKey) + 1
            defaults.set(num, forKey: userLogCountKey)
            defaults.set(total, forKey: userLogCountLifetimeKey)
            userTotalCount = total
            logCount = defaults.integer(forKey: userLogCountKey)
            checkShowSupport()
    }
    
    func setLogCount(num: Int) {
            defaults.set(num, forKey: userLogCountKey)
            logCount = defaults.integer(forKey: userLogCountKey)
    }
    
    func checkShowSupport() {
        showSupportAd = defaults.integer(forKey: userLogCountKey) >= 169
    }
    
    
    
    //MARK: Timed Functions
    func startCountdown(time: Int) {
        timerCountingDown = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(timerDidFireDown), userInfo: nil, repeats: true)
        currentTimedCount = Double(time) + 0.9
        totalTimerDuration = Double(time)
        countdownCount = UserDefaults.standard.double(forKey: countdownKey) + 0.9
        if countdownCount > 1.0 {
            countingState = .countdown
        } else {
            countingState = .counting
        }
        print("Timer started!")
    }
    
    func pause() {
        countingState = .paused
        print("Timer paused!")
    }
    
    func resume() {
        countingState = countdownCount > 0.0 ? .countdown : .counting
        print("Timer resumed!")
    }
    
    func reset() {
        countingState = .ready
        timerCountingDown.invalidate()
        currentTimedCount = 10.0
        percent = 1.0
        timedTaps = 0
        print("Timer reset!")
    }
    
    func finishTimed() {
        timerCountingDown.invalidate()
        let send = Record(date: Date(), taps: timedTaps, timed: true, duration: Int(totalTimerDuration))
        increaseLogCount()
        self.recordingsArr.insert(send, at: 0)
        countingState = .finished
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
    
    func getBPM() -> String {
        let numToComplete = 60/totalTimerDuration
        
        let bpm = Double(timedTaps) * numToComplete
        
        return "\(Int(bpm)) bpm"
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
    
    func getUntimedTimeString() -> String {
        if currentUntimedCount < 10 {
            return "00:0\(currentUntimedCount)"
        } else if currentUntimedCount >= 10 && currentUntimedCount < 60 {
            return "00:\(currentUntimedCount)"
        } else if currentUntimedCount >= 60 && currentUntimedCount < 600 {
            if currentUntimedCount%60 < 10 {
                return "0\(currentUntimedCount/60):0\(currentUntimedCount%60)"
            }
            return "0\(currentUntimedCount/60):\(currentUntimedCount%60)"
        } else {
            if currentUntimedCount%60 < 10 {
                return "\(currentUntimedCount/60):0\(currentUntimedCount%60)"
            }
            return "\(currentUntimedCount/60):\(currentUntimedCount%60)"
        }
    }
    
    func firstTap() {
        startUntimed()
    }
}
//100000000000/60/60/24/365
