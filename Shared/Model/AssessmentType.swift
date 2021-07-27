//
//  AssessmentType.swift
//  AssessmentType
//
//  Created by Collin Dunphy on 7/17/21.
//

import Foundation
import SwiftUI

enum AssessmentType : String, Codable, CaseIterable, Identifiable {
    
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


class Assessment : ObservableObject {
    
    var type : AssessmentType
    
    init(_ type: AssessmentType) {
        self.type = type
    }
    
    var title: String {
        type.title
    }
    
    var color: Color {
        type.color
    }
    
    var symbol: String {
        type.icon
    }
    
    var id: String {
        return title
    }
    
    var finiteTime : Bool = true
}


class TimedAssessment : Assessment {
    
}

class UntimedAssessment : Assessment {
//    override var finiteTime: Bool {
//        get {
//            return false
//        }
//        set {
//
//        }
//    }
    
    override init(_ type: AssessmentType) {
        super.init(type)
        super.finiteTime = false
    }
}

class HeartRateAssessment : TimedAssessment {
    
    init() {
        super.init(.heartRate)
    }
}


struct HeartRateOptions : View {
    var body : some View {
        Section {
            
        }
    }
}
