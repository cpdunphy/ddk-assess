//
//  CustomAssessButtons.swift
//  Diadochokinetic Assess (iOS)
//
//  Created by Collin Dunphy on 11/2/21.
//

import Foundation
import SwiftUI

extension AssessmentTaker {
    
    @ViewBuilder
    var tapButtons : some View {
        switch type {
        case .timed:
            TapButtons.Timed()
        case .count:
            TapButtons.Count()
        case .heartRate:
            TapButtons.HeartRate()
        default:
            EmptyView()
        }
    }
    
}

// MARK: Tap Buttons
extension AssessmentTaker {
    struct TapButtons {
        struct Timed : View {
            @EnvironmentObject var model : TimedAssessment
            
            var body: some View {
                TapButton(
                    taps: $model.taps,
                    countingState: model.countingState
                )
            }
        }
        
        struct Count : View {
            @EnvironmentObject var model : CountingAssessment
            
            var body: some View {
                TapButton(
                    taps: $model.taps,
                    countingState: model.countingState,
                    enabledStates: [[.counting], [.ready]]
                )
            }
        }
        
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
