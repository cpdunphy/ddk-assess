//
//  TimedAssessment.swift
//  Diadochokinetic Assess (iOS)
//
//  Created by Collin Dunphy on 11/2/21.
//

import Foundation
import SwiftUI

class TimedAssessment : TimedAssessmentBase, TimedAssessmentProtocol {

    @AppStorage(StorageKeys.Assessments.showDecimal(.timed)) var showDecimalOnTimer : Bool = true
    @AppStorage(StorageKeys.Assessments.timerLength(.timed)) var duration : Int = 10
    @AppStorage(StorageKeys.Assessments.countdownLength(.timed)) var countdownLength : Int = 3

    @Published var taps : Int = 0
    
    init() {
        super.init(.timed)
    }
    
    override func resetTimer() {
        super.resetTimer()
        taps = 0
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
