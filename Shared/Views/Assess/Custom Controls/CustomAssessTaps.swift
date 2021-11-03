//
//  CustomAssessButtons.swift
//  Diadochokinetic Assess (iOS)
//
//  Created by Collin Dunphy on 11/2/21.
//

import Foundation
import SwiftUI

// MARK: Tap Buttons
extension AssessmentTaker {
    struct TapButtons {
        struct HeartRate : View {
            
            @EnvironmentObject var model : HeartRateAssessment
            
            var body: some View {
                TapButton(
                    taps: $model.taps,
                    countingState: model.countingState
                )
            }
        }
    }
}
