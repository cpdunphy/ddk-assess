//
//  CustomAssessStats.swift
//  Diadochokinetic Assess (iOS)
//
//  Created by Collin Dunphy on 11/2/21.
//

import Foundation
import SwiftUI

extension AssessmentTaker {

    @ViewBuilder
    var statsDisplay: some View {
        switch type {
        case .timed:
            Stats.Timed()
        case .count:
            Stats.Count()
        case .heartRate:
            Stats.HeartRate()
        default:
            EmptyView()
        }
    }

}

// MARK: Customized portions
extension AssessmentTaker {

    // MARK: Stats
    struct Stats {

        struct Timed: View {

            @EnvironmentObject var ddk: DDKModel
            @EnvironmentObject var model: TimedAssessment

            var body: some View {
                GeometryReader { geo in
                    VStack(spacing: 0) {

                        Text(timerDescription)
                            .modifier(BuildingBlocks.TitleFont())
                            .padding(.bottom, 4)

                        //                        BuildingBlocks.Separator()

                        Text(BuildingBlocks.tapDescrition(model.taps))
                            .foregroundColor(.secondary)
                            .modifier(BuildingBlocks.SubtitleFont())

                    }
                    .position(x: geo.size.width / 2, y: geo.size.height / 2)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                #if os(macOS)
                    .background(Color(NSColor.windowBackgroundColor))
                #else
                    .background(Color(.secondarySystemGroupedBackground))
                #endif
                .cornerRadius(15.0)
                .onChange(of: model.currentDateTime, perform: checkStatus)

            }

            var timerDescription: String {
                switch model.countingState {
                case [.countdown], [.countdown, .paused]:
                    return "\(Int(min((model.calculateTimeLeft() ?? 0).rounded(.up), Double(model.countdownLength))))..."
                case [.counting], [.counting, .paused]:
                    return BuildingBlocks.getStandardTimeDisplayString(
                        model.calculateTimeLeft() ?? 0, showDecimal: model.showDecimalOnTimer)
                default:
                    return BuildingBlocks.getStandardTimeDisplayString(Double(model.duration), showDecimal: model.showDecimalOnTimer)
                }
            }

            // Check Status. TODO: Since this is tied to the view, it doesn't transition to the next state if the view is closed.
            func checkStatus(_ newValue: Date) {
                let state = model.countingState

                guard let timeLeft = model.calculateTimeLeft() else {
                    return
                }

                if timeLeft <= 0 {
                    if state.contains(.countdown) {
                        model.transitionToCounting()
                    } else if state.contains(.counting) {
                        model.transitionToFinished()
                        // TODO: Send finished model to DDKModel
                        let record = AssessmentRecord(
                            date: .now,
                            taps: model.taps,
                            type: .timed,
                            duration: Double(model.duration)
                        )
                        ddk.addRecord(record)
                    }
                }
            }
        }

        struct Count: View {

            @EnvironmentObject var ddk: DDKModel
            @EnvironmentObject var model: CountingAssessment

            var body: some View {
                GeometryReader { geo in
                    VStack(spacing: 0) {

                        Text(timerDescription)
                            .modifier(BuildingBlocks.TitleFont())

                        //                        BuildingBlocks.Separator()

                        if model.goalIsEnabled {
                            Text(
                                BuildingBlocks.tapDescrition(model.taps)
                                    + " / \(model.countingGoal)"
                            )
                            .modifier(BuildingBlocks.SubtitleFont())
                        } else {
                            Text(BuildingBlocks.tapDescrition(model.taps))
                                .modifier(BuildingBlocks.SubtitleFont())
                        }

                    }
                    .position(x: geo.size.width / 2, y: geo.size.height / 2)

                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                #if os(iOS)
                    .background(Color(.secondarySystemGroupedBackground))
                #else
                    .background(Color(NSColor.windowBackgroundColor))
                #endif
                .cornerRadius(15.0)
                .onChange(of: model.taps, perform: checkStatus)

            }

            var timerDescription: String {
                return BuildingBlocks.getStandardTimeDisplayString(
                    model.calculateTime() ?? 0,
                    showDecimal: model.showDecimalOnTimer
                )
            }

            // Check Status. TODO: Since this is tied to the view, it doesn't transition to the next state if the view is closed.
            func checkStatus(_ newValue: Int) {

                if newValue == 1 {
                    model.startTimer()
                } else if model.goalIsEnabled && newValue == model.countingGoal {

                    // Goal has been met, save it.
                    model.freezeTimer()
                    let record = AssessmentRecord(
                        date: .now,
                        taps: model.taps,
                        type: .count,
                        duration: model.calculateTime() ?? 0,
                        goal: model.goalIsEnabled ? model.countingGoal : nil
                    )
                    ddk.addRecord(record)
                } else {
                    // Do nothing..
                }
            }
        }

        struct HeartRate: View {

            @EnvironmentObject var ddk: DDKModel
            @EnvironmentObject var model: HeartRateAssessment

            var body: some View {
                GeometryReader { geo in
                    VStack(spacing: 0) {

                        Text(timerDescription)
                            .modifier(BuildingBlocks.TitleFont())

                        //                        BuildingBlocks.Separator()

                        HStack {
                            Text(BuildingBlocks.tapDescrition(model.taps))
                                .modifier(BuildingBlocks.SubtitleFont())

                            Image(systemName: "heart")
                                .symbolVariant(.fill)
                                .foregroundColor(.pink)

                            Text("\(Int(model.heartRate.rounded())) \(model.hrUnit.rawValue.uppercased())")
                                .modifier(BuildingBlocks.SubtitleFont())
                        }

                    }
                    .position(x: geo.size.width / 2, y: geo.size.height / 2)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                #if os(macOS)
                    .background(Color(NSColor.windowBackgroundColor))
                #else
                    .background(Color(.secondarySystemGroupedBackground))
                #endif
                .cornerRadius(15.0)
                .onChange(of: model.currentDateTime, perform: checkStatus)

            }

            var timerDescription: String {
                switch model.countingState {
                case [.countdown], [.countdown, .paused]:
                    return "\(Int(min((model.calculateTimeLeft() ?? 0).rounded(.up), Double(model.countdownLength))))..."
                case [.counting], [.counting, .paused]:
                    return BuildingBlocks.getStandardTimeDisplayString(
                        model.calculateTimeLeft() ?? 0, showDecimal: model.showDecimalOnTimer)
                default:
                    return BuildingBlocks.getStandardTimeDisplayString(Double(model.duration), showDecimal: model.showDecimalOnTimer)
                }
            }

            // Check Status. TODO: Since this is tied to the view, it doesn't transition to the next state if the view is closed.
            func checkStatus(_ newValue: Date) {
                let state = model.countingState

                guard let timeLeft = model.calculateTimeLeft() else {
                    return
                }

                if timeLeft <= 0 {
                    if state.contains(.countdown) {
                        model.transitionToCounting()
                    } else if state.contains(.counting) {
                        model.transitionToFinished()
                        // TODO: Send finished model to DDKModel
                        let record = AssessmentRecord(
                            date: .now,
                            taps: model.taps,
                            type: .heartRate,
                            duration: Double(model.duration)
                        )
                        ddk.addRecord(record)
                    }
                }
            }
        }
    }
}

// Building Blocks
extension AssessmentTaker.BuildingBlocks {

    // Format Time(s) to m/s/ds
    static func getStandardTimeDisplayString(_ time: Double, showDecimal: Bool) -> String {
        // https://stackoverflow.com/questions/35215694/format-timer-label-to-hoursminutesseconds-in-swift/35215847
        // https://stackoverflow.com/questions/52332747/what-are-the-supported-swift-string-format-specifiers/52332748

        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        let deciseconds = time - Double(Int(time))
        var decisecondsFullStr = "\(Double(round(10 * deciseconds) / 10))"
        decisecondsFullStr.remove(at: decisecondsFullStr.startIndex)
        if !showDecimal {
            return String(format: "%02i:%02i", minutes, seconds)
        } else {
            return String(format: "%02i:%02i%3$@", minutes, seconds, decisecondsFullStr)
        }
    }

    static func tapDescrition(_ taps: Int) -> String {
        return "\(taps) \(taps == 1 ? "Tap" : "Taps")"
    }

    struct TitleFont: ViewModifier {
        @ScaledMetric(relativeTo: .largeTitle) var titleFontSize: CGFloat = 48

        func body(content: Content) -> some View {
            return content.font(.system(size: titleFontSize, weight: .bold, design: .rounded).monospacedDigit())
        }
    }

    struct SubtitleFont: ViewModifier {
        @ScaledMetric(relativeTo: .largeTitle) var subtitleFontSize: CGFloat = 24

        func body(content: Content) -> some View {
            return
                content
                .font(Font.system(size: subtitleFontSize, weight: .regular, design: .rounded).monospacedDigit())
        }
    }

    struct Separator: View {

        var width: CGFloat = 95

        var body: some View {
            RoundedRectangle(cornerRadius: 100.0)
                .foregroundColor(.secondary)
                .frame(width: width, height: 4)
                .padding(.vertical, 10)
        }
    }
}
