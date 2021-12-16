//
//  AssessmentType.swift
//  AssessmentType
//
//  Created by Collin Dunphy on 7/17/21.
//

import Combine
import Foundation
import SwiftUI

enum AssessmentType : String, Codable, CaseIterable, Identifiable {
    
    case timed
    case count
    case heartRate
    case swallow
    case fluency
    case disfluency
    case walk
    case physicalTherapy
    
    var title : String {
        switch self {
        case .timed:        return "DDK"
        case .count:        return "Count"
        case .heartRate:    return "Heart Rate"
        case .swallow:      return "Swallow Test"
        case .fluency:      return "Fluency Tracker"
        case .disfluency:   return "Disfluency"
        case .walk:         return "Walking Test"
        case .physicalTherapy: return "Physical Therapy"
        }
    }
    
    var color: Color {
        //TODO: Add these
        switch self {
        case .timed:        return .blue     //#bae1ff
        case .count:        return .orange   //#ffdfba
        case .heartRate:    return .pink     //#ffb3ba
        case .swallow:      return .red
        case .fluency:      return .teal
        case .disfluency:   return .purple
        case .walk:         return .green
        case .physicalTherapy: return .indigo
        }
    }
    
    var icon: String {
        switch self {
        case .timed:            return "waveform"
        case .count:            return "number"
        case .heartRate:        return "heart"
        case .swallow:          return "mouth"
        case .fluency:          return "star"
        case .disfluency:       return "star"
        case .walk:             return "figure.walk"
        case .physicalTherapy:  return "bolt.fill"
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
