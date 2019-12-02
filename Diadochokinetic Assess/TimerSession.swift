//
//  TimerSession.swift
//  Count-My-Taps
//
//  Created by Collin on 11/29/19.
//  Copyright © 2019 Ballygorey Apps. All rights reserved.
//

import Combine
import Foundation
import SwiftUI

class TimerSession: ObservableObject {
    
    @Published var timeCount: Double = 10.0
    @Published var countingState: PossibleCountingStates = .ready
    private var timer = Timer()
    @Published var countdownCount = UserDefaults.standard.double(forKey: countdownKey)
    @Published var percent: Double = 1.0
    private var totalTime: Double = 10.0
    @Published var recordingsArr: [Record] = []
    @Published var taps: Int = 0
    private var timeInterval = 1.0/3.0
    @Published var timedModeActive = defaults.bool(forKey: timedModeKey)
    private var privTimedMode : Bool = true
    
    @objc func timerDidFire() {
        if timeCount > 0.0 && countingState == .counting {
            timeCount -= timeInterval
            if timeCount < 0.1 {
                finish()
            }
        } else if countdownCount > 0.0 && countingState == .countdown {
            countdownCount -= timeInterval
            if countdownCount < 0.1 {
                countingState = .counting
            }
        }
        withAnimation(.easeIn) {
            percent = timeCount/Double(totalTime)
        }
        print("\(countingState)")
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
        timer.invalidate()
        timeCount = 10.0
        percent = 1.0
        taps = 0
        print("Timer reset!")
    }
    func startCountdown(time: Int) {
        timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(timerDidFire), userInfo: nil, repeats: true)
        timeCount = Double(time)
        totalTime = Double(time)
        countdownCount = UserDefaults.standard.double(forKey: countdownKey)
        if countdownCount > 0 {
            countingState = .countdown
        } else {
            countingState = .counting
        }
        privTimedMode = true
        print("Timer started!")
    }
    func finish() {
        timer.invalidate()
        let send = Record(date: Date(), taps: taps, timed: timedModeActive, duration: Int(totalTime))
//        let send = Record()
        self.recordingsArr.insert(send, at: 0)
        countingState = .finished
    }
    func addTaps() {
        taps += 1
    }
}
//100000000000/60/60/24/365
