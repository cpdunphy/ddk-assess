//
//  TimedAssessmentProtocol.swift
//  Diadochokinetic Assess (iOS)
//
//  Created by Collin Dunphy on 3/7/22.
//

import Foundation

protocol TimedAssessmentProtocol {
    var showDecimalOnTimer: Bool { get set }
    var duration: Int { get set }
    var countdownLength: Int { get set }

    func resetTimer()
}
