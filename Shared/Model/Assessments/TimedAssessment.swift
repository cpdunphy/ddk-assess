//
//  TimedAssessment.swift
//  Diadochokinetic Assess (iOS)
//
//  Created by Collin Dunphy on 11/2/21.
//

import Foundation
import SwiftUI

class TimedAssessment : TimedAssessmentBase, TimedAssessmentProtocol, AssessmentProtocol {
    
    @AppStorage(StorageKeys.Assessments.lastUsed(.timed)) var dateLastUsed : Date = Defaults.lastUsed
    
    @AppStorage(StorageKeys.Assessments.timerLength(.timed)) var duration : Int = Defaults.timerDuration
    @AppStorage(StorageKeys.Assessments.countdownLength(.timed)) var countdownLength : Int = Defaults.countdownDuration
    @AppStorage(StorageKeys.Assessments.showDecimal(.timed)) var showDecimalOnTimer : Bool = Defaults.showDecimalOnTimer

    @Published var taps : Int = 0
    
    init() {
        super.init(.timed)
    }
    
    override func startTimer() {
        super.startTimer()
        dateLastUsed = Date()
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
    
    func resetPreferences() {
        duration = Defaults.timerDuration
        countdownLength = Defaults.countdownDuration
        showDecimalOnTimer = Defaults.showDecimalOnTimer
    }
}
