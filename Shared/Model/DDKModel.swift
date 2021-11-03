//
//  DDKModel.swift
//  Diadochokinetic Assess
//
//  Created by Collin Dunphy on 9/23/20.
//

import Combine
import CoreHaptics
import Foundation
import SwiftUI

// MARK: - DDKModel

class DDKModel : ObservableObject {

    
    @AppStorage(StorageKeys.AssessGallery.favoriteAssessments) var favoriteAssessments : Set<String> = []
    
    @AppStorage(StorageKeys.History.pinnedRecords) var pinnedRecords : [AssessmentRecord] = []

    // MARK: Assess Type
    /// Source of truth for the assessment type of the whole app
    @available(*, deprecated, message: "There is no need for a single selection of assessment??")
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
    @Published var records : [AssessmentRecord] = [
        AssessmentRecord(date: .now, taps: 7, type: .timed, duration: 15),
        AssessmentRecord(date: .now, taps: 14, type: .count, duration: 23.6)
    ]
    
    var allRecords: [AssessmentRecord] {
        return records + pinnedRecords
    }
    
    
    // MARK: User Preferences
    
    /// Default Assessment Style. Sets the inital assessment format upon init
    @available(*, unavailable, message: "A default is no longer needed.")
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
    init () {  }

}

// MARK: - Handling Timed
extension DDKModel {
    
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
//        if currentTimedState != [.finished] {
//            currentTimedState = [.finished]
            let record = AssessmentRecord(
                date: Date(),
                taps: currentTimedTaps,
                type: .timed,
                duration: Double(currentlySelectedTimerLength)
            )
            records.insert(record, at: 0)
            totalAssessments += 1
            print(records)
            DDKModel.triggerHapticFeedbackSuccess()
//        }
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
        let record = AssessmentRecord(date: Date(), taps: currentCountTaps, type: .count, duration: duration)
        currentCountTaps = 0
        records.insert(record, at: 0)
        totalAssessments += 1
        DDKModel.triggerHapticFeedbackSuccess()
    }
}

// MARK: - HapticFeedback
extension DDKModel {
    static func triggerHapticFeedbackSuccess() {
        #if os(iOS)
        let hapticFeedback = UINotificationFeedbackGenerator()
        hapticFeedback.notificationOccurred(.success)
        #endif
    }
}


// MARK: - Record Handling

extension DDKModel {
    
    func addRecord(_ record: AssessmentRecord) {
        records.insert(record, at: 0)
        totalAssessments += 1
        DDKModel.triggerHapticFeedbackSuccess()
    }
    
    func updateRecord(_ record: AssessmentRecord) {
        if let index = records.firstIndex(where: { $0.id == record.id }) {
            print("Error: Couldn't find index")
            records[index] = record
        } else if let index = pinnedRecords.firstIndex(where: { $0.id == record.id  }) {
            pinnedRecords[index] = record
        }

    }
    
    func deleteRecord(_ record: AssessmentRecord) {
        records.removeAll(where: { $0.id == record.id })
    }
}

// MARK: - Favorite Assessments
extension DDKModel {
    
    func assessmentTypeIsFavorite(_ type: AssessmentType) -> Bool {
        return favoriteAssessments.contains(type.id)
    }
    
    func toggleFavoriteStatus(_ type: AssessmentType) {
        
        let (inserted, _) = favoriteAssessments.insert(type.id)

        if !inserted {
            favoriteAssessments.remove(type.id)
        }
    }
    
    var isFavoriteAssessmentsEmpty : Bool {
        return AssessmentType.allCases.filter {
            favoriteAssessments.contains($0.id)
        }.isEmpty
    }
    
}

//MARK: - Pinned Records

extension DDKModel {
    
    func recordIsPinned(_ id : UUID) -> Bool {
        return pinnedRecords.contains(where: { id == $0.id })
    }
    
    func pinRecord(_ record: AssessmentRecord) {
        if recordIsPinned(record.id) {
            if let index = pinnedRecords.firstIndex(where: { $0.id == record.id }) {
                pinnedRecords.remove(at: index)
                records.append(record)
            }
            
        } else {
            pinnedRecords.append(record)
            records.removeAll(where: { $0.id == record.id })
            
            print("Pinned Successfully: \(pinnedRecords.count)")
            
            
        }
    }
}
