//
//  CountingState.swift
//  Diadochokinetic Assess
//
//  Created by Collin Dunphy on 9/24/20.
//

import Foundation

enum CountingState {
    case ready
    case counting
    case paused
    case finished
    case countdown
}

enum AssessType {
    case timed
    case count
    
    var label : String {
        switch self {
        case .timed: return "Timed"
        case .count: return "Count"
        }
    }
}
