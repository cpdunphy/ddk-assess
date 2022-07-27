//
//  Defaults.swift
//  Diadochokinetic Assess (iOS)
//
//  Created by Collin Dunphy on 3/7/22.
//

import Foundation

struct Defaults {
    
    public static let lastUsed : Date = .distantPast
    public static let hrDisplayUnit : HeartRateDisplayUnit = .bpm
    
    public static let countdownDuration : Int = 3
    public static let timerDuration : Int = 10
    
    public static let timerRange : ClosedRange<Int> = 1...60
    public static let countdownRange : ClosedRange<Int> = 0...30
    
    public static let showDecimalOnTimer : Bool = true
    
    public static let sortBy : AssessmentSortTypes = .kind
    public static let sortAscending : Bool = true
    
    
    struct Count {
        public static var goal : Int = 10
        public static var goalIsEnabled : Bool = false
    }
}
