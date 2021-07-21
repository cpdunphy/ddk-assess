//
//  AssessmentType.swift
//  AssessmentType
//
//  Created by Collin Dunphy on 7/17/21.
//

import Foundation
import SwiftUI

enum AssessmentType : String, CaseIterable, Identifiable {
    
    case timed
    case count
    case heartRate
    
    var title : String {
        switch self {
        case .timed:        return "Timed"
        case .count:        return "Count"
        case .heartRate:    return "Heart Rate"
        }
    }
    
    var color: Color {
        //TODO: Add these
        switch self {
        case .timed:        return .blue     //#bae1ff
        case .count:        return .orange   //#ffdfba
        case .heartRate:    return .pink     //#ffb3ba
        }
    }
    
    var icon: String {
        switch self {
        case .timed:        return "timer"
        case .count:        return "number"
        case .heartRate:    return "heart"
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
