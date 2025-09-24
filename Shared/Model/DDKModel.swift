//
//  DDKModel.swift
//  Diadochokinetic Assess
//
//  Created by Collin Dunphy on 9/23/20.
//

import Algorithms
import Combine
import CoreHaptics
import Foundation
import SwiftUI

// MARK: - DDKModel

class DDKModel: ObservableObject {

    @AppStorage(StorageKeys.AssessGallery.favoriteAssessments) var favoriteAssessments: Set<String> = []

    @AppStorage(StorageKeys.History.pinnedRecords) var pinnedRecords: [AssessmentRecord] = []

    // MARK: Records

    /// The patient assessment records, doesn't restore from any backup and is cleared upon app quit (can also be cleared via the settings screen)
    @Published var records: [AssessmentRecord] = []

    var allRecords: [AssessmentRecord] {
        //        let combo = records + pinnedRecords
        //        return combo.sorted { $0.date < $1.date }
        return chain(records, pinnedRecords).sorted(by: { $0.date > $1.date })
    }

    // MARK: User Preferences

    /// Countdown Length. Sets how long the timer counts down for before starting the assessment
    @AppStorage("countdown_length") var currentlySelectedCountdownLength: Int = 3

    /// How long the timer should countdown for during timed assessment mode
    @AppStorage("timer_length") var currentlySelectedTimerLength: Int = 10

    /// The total amount of assessments done by the user. Incremented each time an assessment completes via 'finishTimer' & 'logCount'
    @AppStorage("userLogCountTOTAL") var totalAssessments: Int = 0

    @AppStorage("assessment_lifetime_total_distribution") var assessLifetimeTotals: Data = Data()

    @AppStorage("assessment_total_distribution") var assessTotals: Data = Data()

    // MARK: Time References
    /// The latest start of a timed assessment
    @Published var latestTimedDateRef: Date = Date()

    /// The latest start of a count assessment
    @Published var latestCountDateRef: Date = Date()

    // MARK: Timer Utility
    /// Time spent paused on timed mode
    @Published var timeSpentPaused: Double = 0.0

    /// Lastest time a timed assessment was started
    @Published var timeStartLatestPaused: Date = Date()

    /// The latest time a countdown was started
    @Published var timeStartCountdown: Date = Date()

    // MARK: - init
    init() {}

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
        incrementType(record.type)
        DDKModel.triggerHapticFeedbackSuccess()
    }

    func updateRecord(_ record: AssessmentRecord) {
        if let index = records.firstIndex(where: { $0.id == record.id }) {
            print("Error: Couldn't find index")
            records[index] = record
        } else if let index = pinnedRecords.firstIndex(where: { $0.id == record.id }) {
            pinnedRecords[index] = record
        }

    }

    func deleteRecord(_ record: AssessmentRecord) {
        records.removeAll(where: { $0.id == record.id })
        pinnedRecords.removeAll(where: { $0.id == record.id })
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

    var isFavoriteAssessmentsEmpty: Bool {
        return AssessmentType.allCases
            .filter {
                favoriteAssessments.contains($0.id)
            }
            .isEmpty
    }

}

// MARK: - Pinned Records

extension DDKModel {

    func recordIsPinned(_ id: UUID) -> Bool {
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

// MARK: - Assessment Totals
extension DDKModel {

    func getTotal(_ type: AssessmentType) -> Int {

        let totals = retreiveTotals()

        return totals[type] ?? 0
    }

    func incrementType(_ type: AssessmentType) {

        let totals = retreiveTotals()
        let lifeTotals = retreiveLifetimeTotals()
        let currentValue = totals[type] ?? 0
        let currentLifetimeValue = lifeTotals[type] ?? 0

        setTypeValue(for: type, to: currentValue + 1)
        setTypeLifetimeValue(for: type, to: currentLifetimeValue + 1)
    }

    func setTypeValue(for type: AssessmentType, to value: Int) {
        var totals = retreiveTotals()

        totals[type] = value

        guard let newTotals = try? JSONEncoder().encode(totals) else { return }

        assessTotals = newTotals
    }

    func setTypeLifetimeValue(for type: AssessmentType, to value: Int) {
        var totals = retreiveLifetimeTotals()

        totals[type] = value

        guard let newTotals = try? JSONEncoder().encode(totals) else { return }

        assessLifetimeTotals = newTotals
    }

    func resetTypeValue(for type: AssessmentType) {
        setTypeValue(for: type, to: 0)
    }

    func assessCountDescription(_ type: AssessmentType) -> String {
        let total = getTotal(type)

        return "\(total) \(total == 1 ? "assessment" : "assessments")"
    }

    private func retreiveTotals() -> [AssessmentType: Int] {
        guard let decodedTotals = try? JSONDecoder().decode([AssessmentType: Int].self, from: assessTotals) else { return [:] }
        return decodedTotals
    }

    func retreiveLifetimeTotals() -> [AssessmentType: Int] {
        guard let decodedTotals = try? JSONDecoder().decode([AssessmentType: Int].self, from: assessLifetimeTotals) else { return [:] }
        return decodedTotals
    }
}
