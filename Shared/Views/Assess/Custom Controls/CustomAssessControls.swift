//
//  File.swift
//  Diadochokinetic Assess (iOS)
//
//  Created by Collin Dunphy on 11/2/21.
//

import Foundation
import SwiftUI

extension AssessmentTaker {
    
    @ViewBuilder
    var controlButtons : some View {
        switch type {
        case .timed:
            ControlButtons.Timed()
        case .count:
            ControlButtons.Count()
        case .heartRate:
            ControlButtons.HeartRate()
        }
    }
}

// MARK: Controls
extension AssessmentTaker {
    struct ControlButtons {
        
        struct Timed : View {
            @EnvironmentObject var model : TimedAssessment
            
            var body: some View {
                leftButton
                
                rightButton
            }
            
            @ViewBuilder
            var rightButton : some View {
                switch model.countingState {
                case [CountingState.ready]:
                    ButtonOptions.start.button(action: model.startTimer)
                case [CountingState.paused, .counting], [.paused, .countdown]:
                    ButtonOptions.resume.button(action: model.resumeTimer)
                case [CountingState.counting], [.countdown]:
                    ButtonOptions.pause.button(action: model.pauseTimer)
                default:
                    ButtonOptions.reset.button(action: model.resetTimer)
                }
            }
            
            @ViewBuilder
            var leftButton : some View {
                switch model.countingState {
                case [CountingState.ready]:
                    ButtonOptions.reset.button(action: model.resetTimer)
                case [CountingState.countdown], [.counting], [.counting, .paused], [.countdown, .paused]:
                    ButtonOptions.stop.button(action: model.resetTimer)
                default:
                    ButtonOptions.reset.button(action: model.resetTimer)
                }
            }
        }
        
        struct Count : View {
            
            @EnvironmentObject var ddk : DDKModel
            @EnvironmentObject var model : CountingAssessment
            
            var body: some View {
                ButtonOptions.reset.button {
                    model.resetTimer()
                }
                
                ButtonOptions.log.button {
                    let record = AssessmentRecord(
                        date: .now,
                        taps: model.taps,
                        type: .count,
                        duration: model.calculateTime() ?? 0
                    )
                    ddk.addRecord(record)
                    model.resetTimer()
                }
            }
        }
        

        
        struct HeartRate : View {
            @EnvironmentObject var model : HeartRateAssessment
            
            var body: some View {
                leftButton
                
                rightButton
            }
            
            @ViewBuilder
            var rightButton : some View {
                switch model.countingState {
                case [CountingState.ready]:
                    ButtonOptions.start.button(action: model.startTimer)
                case [CountingState.paused, .counting], [.paused, .countdown]:
                    ButtonOptions.resume.button(action: model.resumeTimer)
                case [CountingState.counting], [.countdown]:
                    ButtonOptions.pause.button(action: model.pauseTimer)
                default:
                    ButtonOptions.reset.button(action: model.resetTimer)
                }
            }
            
            @ViewBuilder
            var leftButton : some View {
                switch model.countingState {
                case [CountingState.ready]:
                    ButtonOptions.reset.button(action: model.resetTimer)
                case [CountingState.countdown], [.counting], [.counting, .paused], [.countdown, .paused]:
                    ButtonOptions.stop.button(action: model.resetTimer)
                default:
                    ButtonOptions.reset.button(action: model.resetTimer)
                }
            }
        }
        
    }
}

// Building Blocks
extension AssessmentTaker.BuildingBlocks {
    struct ControlButton : View {
        var title: String
        var systemImage: String
        var color: Color
        
        var action : () -> Void
        
        var body: some View {
            Button(action: action) {
                Label(title, systemImage: systemImage)
                    .lineLimit(2)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .tint(color)
            .font(.title2)
        }
    }
    
}
