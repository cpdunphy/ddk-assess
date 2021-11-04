//
//  HeartRateAssessment.swift
//  Diadochokinetic Assess (iOS)
//
//  Created by Collin Dunphy on 11/2/21.
//

import Foundation
import SwiftUI

class HeartRateAssessment : TimedAssessmentBase, TimedAssessmentProtocol {
    
    @AppStorage("heart_rate_unit") var heartRate : HeartRateDisplayUnit = Defaults.hrDisplayUnit
    @AppStorage(StorageKeys.Assessments.timerLength(.heartRate)) var duration : Int = Defaults.timerDuration
    @AppStorage(StorageKeys.Assessments.countdownLength(.heartRate)) var countdownLength : Int = Defaults.countdownDuration
    @AppStorage(StorageKeys.Assessments.showDecimal(.heartRate)) var showDecimalOnTimer : Bool = Defaults.showDecimalOnTimer
    
    @Published var taps : Int = 0

    init() {
        super.init(.heartRate)
    }
    
    override func resetTimer() {
        super.resetTimer()
        taps = 0
    }
    
    func calculateHeartRate() -> Int {
        
        switch heartRate {
        case .bpm:
            return Int(60.0 / (Double(duration) - (calculateTimeLeft() ?? 1)) * Double(taps))
        case .bps:
            return Int(Double(taps) / (Double(duration) - (calculateTimeLeft() ?? 1)))
        }
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
}
