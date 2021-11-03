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
}
