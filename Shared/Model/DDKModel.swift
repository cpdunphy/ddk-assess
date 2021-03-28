//
//  DDKModel.swift
//  Diadochokinetic Assess
//
//  Created by Collin Dunphy on 9/23/20.
//

import Foundation
import Combine
import SwiftUI
import CoreHaptics
// MARK: - DDKModel

class DDKModel : ObservableObject {
        
    // MARK: Assess Type
    /// Source of truth for the assessment type of the whole app
    @Published var assessType : AssessType = .timed
    
    /// Sets the currently selected view's referenceDate equal to the current date
    func syncTimeRef(_ override: AssessType? = nil) {
        switch override ?? assessType {
        case .timed:
            latestTimedDateRef = Date()
        case .count:
            latestCountDateRef = Date()
        }
    }
    
    
    // MARK: Tap Count
    
    /// Current number of taps in timed mode
    @Published var currentTimedTaps : Int = 0
    
    /// Current number of taps in count mode
    @Published var currentCountTaps : Int = 0
    
    /// Outputs the current number of taps based on the currently selected 'assessType'
    var currentTaps : Int {
        switch self.assessType {
        case .timed:
            return currentTimedTaps
        case .count:
            return currentCountTaps
        }
    }

    // MARK: Counting States
    /// Monitors the state of the current state of the timed mode. This is a set due to the variety of possibilities the timed state can be in
    @Published var currentTimedState : Set<CountingState> = [.ready]
    
    /// Monitors the state of the current state of the timed mode
    @Published var currentCountState : CountingState = .ready
    
        
    // MARK: Records
    
    /// The patient assessment records, doesn't restore from any backup and is cleared upon app quit (can also be cleared via the settings screen)
    @Published var records : [AssessmentRecord] = []
    
    
    // MARK: User Preferences
    
    /// Default Assessment Style. Sets the inital assessment format upon init
    @AppStorage("default_assessment_style") var defaultAssessmentType : AssessType = .timed
    
    /// Countdown Length. Sets how long the timer counts down for before starting the assessment
    @AppStorage("countdown_length") var currentlySelectedCountdownLength: Int = 3
    
    
    /// How long the timer should countdown for during timed assessment mode
    @AppStorage("timer_length") var currentlySelectedTimerLength: Int = 10
    
    /// The total amount of assessments done by the user. Incremented each time an assessment completes via 'finishTimer' & 'logCount'
    @AppStorage("userLogCountTOTAL") var totalAssessments : Int = 0
    

    // MARK: Time References
    /// The latest start of a timed assessment
    @Published var latestTimedDateRef : Date = Date()
    
    /// The latest start of a count assessment
    @Published var latestCountDateRef : Date = Date()
       
    
    // MARK: Timer Utility
    /// Time spent paused on timed mode
    @Published var timeSpentPaused : Double = 0.0
    
    /// Lastest time a timed assessment was started
    @Published var timeStartLatestPaused : Date = Date()
    
    /// The latest time a countdown was started
    @Published var timeStartCountdown : Date = Date()
    
    // MARK: - init
    init () {
        assessType = defaultAssessmentType
    }

}

// MARK: - Handling Timed
extension DDKModel {

    func handleTimedTaps() {
        print("DDKModel: handleTimedTaps()")
        currentTimedTaps += 1
    }
    
    func handleTaps() {
        switch assessType {
        case .timed:
            handleTimedTaps()
        case .count:
            handleCountTaps()
        }
    }
    
    func stopTimed() {
        currentTimedState = [.ready]
        timeSpentPaused = 0
    }
    
    func pauseTimed() {
        currentTimedState.insert(.paused)
        timeStartLatestPaused = Date()
    }
    
    func startTimed() {
        currentTimedState = [.countdown]
        syncTimeRef()
    }
    
    func resetTimed() {
        currentTimedState = [.ready]
        timeSpentPaused = 0
        currentTimedTaps = 0
    }
    
    func resumeTimed() {
        currentTimedState.remove(.paused)
        let duration = Date().timeIntervalSince(timeStartLatestPaused)
        timeSpentPaused += duration
    }
    
    func finishTimer() {
        if currentTimedState != [.finished] {
            currentTimedState = [.finished]
            let record = AssessmentRecord(
                date: Date(),
                taps: currentTimedTaps,
                timed: true,
                duration: Double(currentlySelectedTimerLength)
            )
            records.insert(record, at: 0)
            totalAssessments += 1
            print(records)
            triggerHapticFeedbackSuccess()
        }
    }
    
    func finishCountdown() {
        currentTimedState = [.counting]
        timeSpentPaused = 0
        syncTimeRef(.timed)
    }
}

// MARK: - Handling Count
extension DDKModel {
    
    func handleCountTaps() {
        print("handleCountTaps()")
        if currentCountTaps == 0 {
            print("Starting initial taps")
            syncTimeRef()
            currentCountState = .counting
        }
        currentCountTaps += 1
    }
    
    func resetCount() {
        currentCountState = .ready
        currentCountTaps = 0
    }
    
    func logCount() {
        currentCountState = .ready
        var duration: Double = abs(latestCountDateRef.timeIntervalSince(Date()))
        if currentCountTaps == 0 {
            duration = 0.0
        }
        let record = AssessmentRecord(date: Date(), taps: currentCountTaps, timed: false, duration: duration)
        currentCountTaps = 0
        records.insert(record, at: 0)
        totalAssessments += 1
        triggerHapticFeedbackSuccess()
    }
}

// MARK: - HapticFeedback
extension DDKModel {
    func triggerHapticFeedbackSuccess() {
        #if os(iOS)
        let hapticFeedback = UINotificationFeedbackGenerator()
        hapticFeedback.notificationOccurred(.success)
        #endif
    }
}
