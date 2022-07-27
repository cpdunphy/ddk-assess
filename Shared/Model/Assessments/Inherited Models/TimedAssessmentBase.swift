//
//  TimedAssessmentBase.swift
//  Diadochokinetic Assess (iOS)
//
//  Created by Collin Dunphy on 11/2/21.
//

import Foundation

class TimedAssessmentBase : Assessment {
    
    /// Monitors the state of the current state of the timed mode. This is a set due to the variety of possibilities the timed state can be in
    @Published var countingState : Set<CountingState> = [.ready]
    @Published var startOfAssessment : Date = Date.now
    
    /// Time spent paused on timed mode
    @Published var timeSpentPaused : Double = 0.0
    
    /// Lastest time a timed assessment was started
    @Published var timeOfLatestPause : Date = Date()
    
    override init(_ type: AssessmentType) {
        super.init(type)
    }
    
    
    // MARK: - Button Controls

    func startTimer() {
        resetTimer()
        countingState = [.countdown]
        startOfAssessment = Date.now
    }
    
    func pauseTimer() {
        countingState.insert(.paused)
        timeOfLatestPause = Date.now
    }
    
    func resumeTimer() {
        countingState.remove(.paused)
        let duration = Date.now.timeIntervalSince(timeOfLatestPause)
        timeOfLatestPause += duration
    }
    
    func resetTimer() {
        countingState = [.ready]
    }
    
    func transitionToCounting() {
        countingState = [.counting]
        timeSpentPaused = 0
        startOfAssessment = .now
    }
    
    func transitionToFinished() {
        if countingState != [.ready] {
            countingState = [.ready]
        }
    }
}
