//
//  Diadochokinetic_AssessApp.swift
//  Shared
//
//  Created by Collin Dunphy on 9/23/20.
//

import SwiftUI

@main
struct Diadochokinetic_AssessApp: App {
    
    /// Initial declaration and initiation of 'DDKModel'
    @StateObject private var ddkModel : DDKModel = DDKModel()
    
    
    
    /// Initial declaration and initiation of 'HeartRateAssessment'
    @StateObject private var timed : TimedCountingAssessment = TimedCountingAssessment()
    
    /// Initial declaration and initiation of 'HeartRateAssessment'
    @StateObject private var count : CountingAssessment = CountingAssessment()
    
    /// Initial declaration and initiation of 'HeartRateAssessment'
    @StateObject private var heartRate : HeartRateAssessment = HeartRateAssessment()
    
    
    
    /// Initial declaration and initiation of 'Store'
    @StateObject private var store : Store = Store()
    
    /// Initial declaration and initiation of 'TimerSession'
    @StateObject private var timerSession : TimerSession = TimerSession()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(ddkModel)
                .environmentObject(timerSession)
                .environmentObject(store)
                .environmentObject(timed)
                .environmentObject(count)
                .environmentObject(heartRate)
        }
    }
}
