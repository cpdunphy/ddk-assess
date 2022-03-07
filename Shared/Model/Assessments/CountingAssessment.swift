//
//  CountingAssessment.swift
//  Diadochokinetic Assess (iOS)
//
//  Created by Collin Dunphy on 11/2/21.
//

import Foundation
import SwiftUI

class CountingAssessment : Assessment, AssessmentProtocol {
    
    @AppStorage(StorageKeys.Assessments.lastUsed(.count)) var dateLastUsed : Date = Defaults.lastUsed
    @AppStorage(StorageKeys.Assessments.Count.goalIsEnabled) var goalIsEnabled : Bool = Defaults.Count.goalIsEnabled
    @AppStorage(StorageKeys.Assessments.Count.goal) var countingGoal : Int = Defaults.Count.goal
    @AppStorage(StorageKeys.Assessments.showDecimal(.timed)) var showDecimalOnTimer : Bool = Defaults.showDecimalOnTimer
    
    @Published var taps : Int = 0
    @Published var countingState : Set<CountingState> = [.ready]
    @Published var startOfAssessment : Date = .now
    @Published var endOfAssessment : Date = .now
    
    init() {
        super.init(.count)
    }
    
    func startTimer() {
        countingState = [.counting]
        startOfAssessment = Date.now
        dateLastUsed = Date.now
    }
    
    func freezeTimer() {
        countingState = [.paused]
        endOfAssessment = currentDateTime
    }
    
    func resetTimer() {
        countingState = [.ready]
        taps = 0
    }
    
    func calculateTime() -> Double? {
        let start = startOfAssessment
        
        if countingState.contains(.counting) {
            return max(0, currentDateTime.timeIntervalSince(start))
        } else if countingState.contains(.paused) {
            let end = endOfAssessment
            return end.timeIntervalSince(start)
        }
        
        return nil
    }
    
    func resetPreferences() {
        goalIsEnabled = Defaults.Count.goalIsEnabled
        countingGoal = Defaults.Count.goal
        showDecimalOnTimer = Defaults.showDecimalOnTimer
    }
}
