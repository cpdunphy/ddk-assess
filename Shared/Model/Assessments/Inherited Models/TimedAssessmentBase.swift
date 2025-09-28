//
//  TimedAssessmentBase.swift
//  Diadochokinetic Assess (iOS)
//
//  Created by Collin Dunphy on 11/2/21.
//

import Foundation

class TimedAssessmentBase: Assessment {

    /// Monitors the state of the current state of the timed mode. This is a set due to the variety of possibilities the timed state can be in
    @Published var countingState: Set<CountingState> = [.ready]
    @Published var startOfAssessment: Date = .now

    /// Time spent paused on timed mode
    @Published var timeSpentPaused: Double = 0.0

    /// Lastest time a timed assessment was started
    @Published var timeOfLatestPause: Date = .now

    override init(_ type: AssessmentType) {
        super.init(type)
    }

    // MARK: - Button Controls

    func startTimer() {
        resetTimer()
        countingState = [.countdown]
        startOfAssessment = .now
    }

    func pauseTimer() {
        guard !countingState.contains(.paused) else { return }
        countingState.insert(.paused)
        timeOfLatestPause = .now
    }

    func resumeTimer() {
        guard countingState.contains(.paused) else { return }
        let duration = Date.now.timeIntervalSince(timeOfLatestPause)
        timeSpentPaused += duration
        countingState.remove(.paused)
    }

    func resetTimer() {
        countingState = [.ready]
        timeSpentPaused = 0
        startOfAssessment = .now
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
