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
    var options: some View {
        switch type {
        case .timed:
            Timed()
        case .count:
            Count()
        case .heartRate:
            HeartRate()
        default:
            EmptyView()
        }
    }

    struct Timed: View {
        @EnvironmentObject var model: TimedAssessment

        var body: some View {

            Section("Duration") {
                BuildingBlocks.DurationPicker(value: $model.duration)
                BuildingBlocks.CountdownStepper(countdown: $model.countdownLength)
            }
            .disabled(isDisabled(model.countingState))

            Section {
                Toggle("Show Decimal on Timer", isOn: $model.showDecimalOnTimer)
            }
        }
    }

    struct Count: View {
        @EnvironmentObject var model: CountingAssessment

        var body: some View {

            Section {
                Toggle(
                    "Rep Goal",
                    isOn: $model.goalIsEnabled
                )

                if model.goalIsEnabled {
                    BuildingBlocks.DurationPicker(
                        value: $model.countingGoal,
                        range: 1...100,
                        title: "Set your goal"
                    )
                }

            } footer: {
                Text("Select the number of reps you want to reach and the timer will stop when you reach that goal.")
            }
            .disabled(isDisabled(model.countingState))

            Section {
                Toggle("Show Decimal on Timer", isOn: $model.showDecimalOnTimer)
            }
        }
    }

    struct HeartRate: View {
        @EnvironmentObject var model: HeartRateAssessment

        var body: some View {
            Section("Duration") {
                BuildingBlocks.DurationPicker(value: $model.duration)
                BuildingBlocks.CountdownStepper(countdown: $model.countdownLength)
            }
            .disabled(isDisabled(model.countingState))

            Section {
                Toggle("Show Decimal on Timer", isOn: $model.showDecimalOnTimer)
            }

            Section {
                Picker("Display Unit", selection: $model.hrUnit) {
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

    static func isDisabled(_ state: Set<CountingState>) -> Bool {
        return state.contains(.counting) || state.contains(.countdown)
    }

    struct BuildingBlocks {

        struct DurationPicker: View {

            @Binding var value: Int
            var range: ClosedRange<Int>
            var title: String

            init(value: Binding<Int>, range: ClosedRange<Int> = Defaults.timerRange, title: String = "Set the Seconds") {
                self._value = value
                self.range = range
                self.title = title

                if !range.contains(self.value) {
                    self.value = Defaults.timerDuration
                }
            }

            var body: some View {
                Picker("Set the Seconds", selection: $value) {
                    ForEach(range, id: \.self) {
                        Text("\($0)").tag($0)
                    }
                }
                #if os(iOS)
                    .pickerStyle(.wheel)
                #endif
            }
        }

        struct CountdownStepper: View {

            @Binding var countdown: Int
            var range: ClosedRange<Int>

            init(countdown: Binding<Int>, range: ClosedRange<Int> = Defaults.countdownRange) {
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
