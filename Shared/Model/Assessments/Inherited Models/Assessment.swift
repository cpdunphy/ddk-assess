//
//  Assessment.swift
//  Diadochokinetic Assess (iOS)
//
//  Created by Collin Dunphy on 11/2/21.
//

import Combine
import Foundation
import SwiftUI

class Assessment : ObservableObject {
    
    var type : AssessmentType
    
    private var timer : AnyCancellable?
    @Published var currentDateTime : Date = .now

    init(_ type: AssessmentType) {
        self.type = type
        self.timer = Timer.publish(every: 0.1, on: .main, in: .default)
            .autoconnect()
            .sink(receiveValue: { time in
                self.currentDateTime = time
            })
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
}

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


