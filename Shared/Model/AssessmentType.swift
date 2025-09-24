//
//  AssessmentType.swift
//  AssessmentType
//
//  Created by Collin Dunphy on 7/17/21.
//

import Combine
import Foundation
import SwiftUI

enum AssessmentType: String, Codable, CaseIterable, Identifiable {

    case timed
    case count
    case heartRate
    //    case fluency
    //    case physiopedia
    //    case walk
    //    case exercise

    var title: String {
        switch self {
        case .timed: return "DDK"
        case .count: return "Count"
        case .heartRate: return "Heart Rate"
        //        case .fluency:      return "Fluency Tracker"
        //        case .walk:         return "Walking Timer"
        //        case .exercise:     return "Exercise Timer"
        //        case .physiopedia:  return "Sit to Stand"
        }
    }

    var color: Color {
        //TODO: Add these
        switch self {
        case .timed: return .blue  //#bae1ff
        case .count: return .orange  //#ffdfba
        case .heartRate: return .pink  //#ffb3ba
        //        case .fluency:      return .red
        //        case .walk:         return .green
        //        case .physiopedia:  return .teal
        //        case .exercise:     return .indigo
        }
    }

    var icon: String {
        switch self {
        case .timed: return "waveform"
        case .count: return "number"
        case .heartRate: return "heart"
        //        case .fluency:      return "mouth"
        //        case .physiopedia:  return "figure.stand"
        //        case .walk:         return "figure.walk"
        //        case .exercise:     return "bolt.fill"
        }
    }

    var description: String {
        //TODO: Add these
        return ""
    }

    var id: String {
        return self.rawValue
    }
}
