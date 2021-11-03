//
//  CustomAssessOptions.swift
//  Diadochokinetic Assess (iOS)
//
//  Created by Collin Dunphy on 11/2/21.
//

import Foundation
import SwiftUI

// MARK: - Custom Options Editors
extension AssessmentOptions {
    
    @ViewBuilder
    var options : some View {
        switch type {
        case .timed:
            Timed()
        case .count:
            Count()
        case .heartRate:
            HeartRate()
        }
    }
    
    struct Timed : View {
        @EnvironmentObject var model : TimedAssessment
        
        var body : some View {
            
            Section("Duration") {
                BuildingBlocks.DurationPicker(duration: $model.duration)
                BuildingBlocks.CountdownStepper(countdown: $model.countdownLength)
            }
            
            Section {
                Toggle("Show Decimal on Timer", isOn: $model.showDecimalOnTimer)
            }
        }
    }

    struct Count : View {
        @EnvironmentObject var model : CountingAssessment
        
        var body : some View {
            Section {
                Toggle("Show Decimal on Timer", isOn: $model.showDecimalOnTimer)
            }
        }
    }
    
    struct HeartRate : View {
        @EnvironmentObject var model : HeartRateAssessment
        
        var body : some View {
            
            Section("Duration") {
                BuildingBlocks.DurationPicker(duration: $model.duration)
                BuildingBlocks.CountdownStepper(countdown: $model.countdownLength)
            }
            
            Section {
                Toggle("Show Decimal on Timer", isOn: $model.showDecimalOnTimer)
            }
            
            Section {
                Picker("Display Unit", selection: $model.heartRate) {
                    ForEach(HeartRateDisplayUnit.allCases) {
                        Text($0.rawValue).tag($0)
                    }
                }
            }
        }
    }
}

// MARK: - Building Blocks
extension AssessmentOptions {
    
    struct BuildingBlocks {
        
        struct DurationPicker : View {
            
            @Binding var duration : Int
            var range : ClosedRange<Int>
            
            init (duration: Binding<Int>, range: ClosedRange<Int> = Defaults.timerRange) {
                self._duration = duration
                self.range = range
                if !range.contains(self.duration) {
                    self.duration = Defaults.timerDuration
                }
            }
            
            var body: some View {
                Picker("Set the Seconds", selection: $duration) {
                    ForEach(range, id: \.self) {
                        Text("\($0)").tag($0)
                    }
                }.pickerStyle(.wheel)
            }
        }
        
        struct CountdownStepper : View {
            
            @Binding var countdown : Int
            var range: ClosedRange<Int>
            
            init (countdown: Binding<Int>, range: ClosedRange<Int> = Defaults.countdownRange) {
                self._countdown = countdown
                self.range = range
                if !range.contains(self.countdown) {
                    self.countdown = Defaults.countdownDuration
                }
            }
            var body: some View {
                Stepper("Countdown for \(countdown) \(countdown == 1 ? "sec" : "secs")", value: $countdown, in: range)
            }
        }
    }
    
}

