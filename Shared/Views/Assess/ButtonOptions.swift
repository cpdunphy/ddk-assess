//
//  ButtonOptions.swift
//  Diadochokinetic Assess (iOS)
//
//  Created by Collin Dunphy on 10/15/21.
//

import Foundation
import SwiftUI

extension AssessmentTaker {

    enum ButtonOptions {
        case start
        case resume
        case pause
        case stop
        case reset
        case log

        func button(action: @escaping () -> Void) -> some View {
            AssessmentTaker.BuildingBlocks.ControlButton(
                title: self.title,
                systemImage: self.systemSymbol,
                color: self.color,
                action: action
            )
        }

        var systemSymbol: String {
            switch self {
            case .start: return "stopwatch"
            case .resume: return "play.fill"
            case .pause: return "pause.fill"
            case .stop: return "stop.fill"
            case .reset: return "gobackward"
            case .log: return "square.and.pencil"
            }
        }

        var title: String {
            switch self {
            case .start: return "Start"
            case .resume: return "Resume"
            case .pause: return "Pause"
            case .stop: return "Stop"
            case .reset: return "Reset"
            case .log: return "Log"
            }
        }

        var color: Color {
            switch self {
            case .start: return Color.green
            case .resume: return Color.green
            case .pause: return Color.orange
            case .stop, .reset:
                #if os(iOS)
                    return Color.gray
                #elseif os(macOS)
                    return Color.white
                #else
                    return Color.gray
                #endif
            case .log: return Color.orange
            }
        }
    }

}
