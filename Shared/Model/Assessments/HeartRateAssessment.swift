//
//  HeartRateAssessment.swift
//  Diadochokinetic Assess (iOS)
//
//  Created by Collin Dunphy on 11/2/21.
//

import Foundation
import SwiftUI

class HeartRateAssessment : TimedAssessmentBase, TimedAssessmentProtocol, AssessmentProtocol {
    
    @AppStorage(StorageKeys.Assessments.lastUsed(.timed)) var dateLastUsed : Date = Defaults.lastUsed
    @AppStorage(StorageKeys.Assessments.HeartRate.unit) var hrUnit : HeartRateDisplayUnit = Defaults.hrDisplayUnit
    @AppStorage(StorageKeys.Assessments.timerLength(.heartRate)) var duration : Int = Defaults.timerDuration
    @AppStorage(StorageKeys.Assessments.countdownLength(.heartRate)) var countdownLength : Int = Defaults.countdownDuration
    @AppStorage(StorageKeys.Assessments.showDecimal(.heartRate)) var showDecimalOnTimer : Bool = Defaults.showDecimalOnTimer
    
    @Published var taps : Int = 0

    init() {
        super.init(.heartRate)
    }
    
    override func startTimer() {
        super.startTimer()
        dateLastUsed = Date.now
    }
    
    override func resetTimer() {
        super.resetTimer()
        taps = 0
    }
    
    static func calculateHeartRate(unit: HeartRateDisplayUnit, taps: Int, duration: Double) -> Double {
        
        if duration == 0.0 {
            return 0
        }
        
        switch unit {
        case .bpm:
            return 60.0 / duration * Double(taps)
        case .bps:
            return Double(taps) / (duration)
        }
    }
    
    // Computed HR For the assessment (overall logic in the static method 'calculateHeartRate()'
    var heartRate : Double {
        HeartRateAssessment.calculateHeartRate(unit: hrUnit, taps: taps, duration: Double(duration) - (calculateTimeLeft() ?? 0))
    }
    
    // TODO: How can I move this higher in the inheritance stack.. I don't think I can since it references countdown and duration, which are stored in the actual top class.
    func calculateTimeLeft() -> Double? {
        
        let state = countingState
        
        var start = startOfAssessment
        let timeSpentPaused = timeSpentPaused
        
        start.addTimeInterval(timeSpentPaused)
        
        switch state {
        case [.paused, .countdown]:
            return start
                .addingTimeInterval(TimeInterval(countdownLength))
                .timeIntervalSince(timeOfLatestPause)
        case [.countdown]:
            return start
                .addingTimeInterval(TimeInterval(countdownLength))
                .timeIntervalSince(currentDateTime)
        case [.paused, .counting]:
            return start
                .addingTimeInterval(TimeInterval(duration))
                .timeIntervalSince(timeOfLatestPause)
        case [.counting]:
            return start
                .addingTimeInterval(TimeInterval(duration))
                .timeIntervalSince(currentDateTime)
        default:
            return nil
        }
    }
    
    func resetPreferences() {
        hrUnit = Defaults.hrDisplayUnit
        duration = Defaults.timerDuration
        countdownLength = Defaults.countdownDuration
        showDecimalOnTimer = Defaults.showDecimalOnTimer
    }
}
