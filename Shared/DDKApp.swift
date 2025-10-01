//
//  Diadochokinetic_AssessApp.swift
//  Shared
//
//  Created by Collin Dunphy on 9/23/20.
//

import SwiftUI

@main
struct DDKApp: App {

    @StateObject private var ddk: DDKModel = DDKModel()

    // Assessment Models
    @StateObject private var timed: TimedAssessment = TimedAssessment()
    @StateObject private var count: CountingAssessment = CountingAssessment()
    @StateObject private var heartRate: HeartRateAssessment = HeartRateAssessment()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(ddk)
                .environmentObject(timed)
                .environmentObject(count)
                .environmentObject(heartRate)
        }
    }
}
