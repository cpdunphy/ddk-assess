//
//  DDKModel.swift
//  Diadochokinetic Assess
//
//  Created by Collin Dunphy on 9/23/20.
//

import Foundation
import Combine
import SwiftUI
// MARK: - DDKModel

class DDKModel : ObservableObject {
    
    @Published var latestTimedDateRef : Date = Date()
    @Published var latestCountDateRef : Date = Date()
    
    var referenceDate : Date {
        switch self.assessType {
        case .timed:
            return latestTimedDateRef
        case .count:
            return latestCountDateRef
        }
    }
    @AppStorage("default_assessment_style") var defaultAssessmentType : AssessType = .timed
    @Published var assessType : AssessType = .timed
    
    /// Sets the currently selected view's referenceDate equal to the current date
    func syncTimeRef() {
        switch assessType {
        case .timed:
            latestTimedDateRef = Date()
        case .count:
            latestCountDateRef = Date()
        }
    }
    
    init () {
        assessType = defaultAssessmentType
    }
    
    @Published var currentTimedTaps : Int = 0
    @Published var currentCountTaps : Int = 0
    
    var currentTaps : Int {
        switch self.assessType {
        case .timed:
            return currentTimedTaps
        case .count:
            return currentCountTaps
        }
    }

    @Published var currentTimedState : Set<CountingState> = [.ready]
    @Published var currentCountState : CountingState = .ready
    
    @Published var records : [Record] = []
    
    @AppStorage("countdown_length") var currentlySelectedCountdownLength: Int = 3
    @AppStorage("timer_length") var currentlySelectedTimerLength: Int = 10
    @AppStorage("userLogCountTOTAL") var totalAssessments : Int = 0
    
    @Published var timeSpentPaused : Double = 0.0
    @Published var timeStartLatestPaused : Date = Date()
    @Published var timeStartCountdown : Date = Date()
}

//MARK: - Handling Timed
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
            let record = Record(date: Date(), taps: currentTimedTaps, timed: true, duration: Double(currentlySelectedTimerLength))
            records.insert(record, at: 0)
            print(records)
        }
    }
    
    func finishCountdown() {
        currentTimedState = [.counting]
        timeSpentPaused = 0
        syncTimeRef()
    }
}

//MARK: - Handling Count
extension DDKModel {
    
    func handleCountTaps() {
        print("DDKModel: handleCountTaps()")
        if currentCountTaps == 0 {
            print("DDKModel: handleCountTaps(): Starting inital taps")
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
        let record = Record(date: Date(), taps: currentCountTaps, timed: false, duration: abs(latestCountDateRef.timeIntervalSince(Date())))
        currentCountTaps = 0
        records.insert(record, at: 0)
        totalAssessments += 1
    }
    
}

