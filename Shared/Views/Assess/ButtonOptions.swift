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
        case start, resume, pause, stop, reset, log

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
            case .start: return .green
            case .resume: return .green
            case .pause: return .orange
            case .stop, .reset: return .gray
            case .log: return .orange
            }
        }
    }

}
