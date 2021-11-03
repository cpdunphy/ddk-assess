//
//  CountingAssessment.swift
//  Diadochokinetic Assess (iOS)
//
//  Created by Collin Dunphy on 11/2/21.
//

import Foundation
import SwiftUI

class CountingAssessment : Assessment {
    
    @AppStorage(StorageKeys.Assessments.showDecimal(.timed)) var showDecimalOnTimer : Bool = Defaults.showDecimalOnTimer
    
    @Published var taps : Int = 0
    @Published var countingState : Set<CountingState> = [.ready]
    @Published var startOfAssessment : Date = .now
        
    init() {
        super.init(.count)
    }
    
    func startTimer() {
        countingState = [.counting]
        startOfAssessment = Date.now
    }
    
    func resetTimer() {
        countingState = [.ready]
        taps = 0
    }
    
    func calculateTimeLeft() -> Double? {
        let start = startOfAssessment
        
        if countingState.contains(.counting) {
            return max(0, currentDateTime.timeIntervalSince(start))
        }
        
        return nil
    }
}
