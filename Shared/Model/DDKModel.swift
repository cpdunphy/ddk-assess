//
//  DDKModel.swift
//  Diadochokinetic Assess
//
//  Created by Collin Dunphy on 9/23/20.
//

import Foundation
import Combine

// MARK: - DDKModel

class DDKModel : ObservableObject {
    
    @Published var latestTimedDateRef : Date = Date()
    @Published var latestCountDateRef : Date = Date()
    
    var referenceDate : Date {
        switch self.assessType {
        case .timed:
            return latestTimedDateRef
        case .count:
            return latestCountDateRef
        }
    }
    
    @Published var assessType : AssessType = .timed
    
    /// Sets the currently selected view's referenceDate equal to the current date
    func syncTimeRef() {
        switch assessType {
        case .timed:
            latestTimedDateRef = Date()
        case .count:
            latestCountDateRef = Date()
        }
    }
    
    init () {}
    
    @Published var currentTimedTaps : Int = 0
    @Published var currentCountTaps : Int = 0
    
    var currentTaps : Int {
        switch self.assessType {
        case .timed:
            return currentTimedTaps
        case .count:
            return currentCountTaps
        }
    }
    
    @Published var currentTimedState : CountingState = .ready
    @Published var currentCountState : CountingState = .ready
    
}
