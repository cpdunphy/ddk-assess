//
//  Diadochokinetic_AssessApp.swift
//  Shared
//
//  Created by Collin Dunphy on 9/23/20.
//

import SwiftUI

@main
struct Diadochokinetic_AssessApp: App {
    
    /// Inital declaration and initation of 'DDKModel'
    @StateObject private var ddkModel : DDKModel = DDKModel()
    
    /// Inital declaration and initation of 'Store'
    @StateObject private var store : Store = Store()
    
    /// Inital declaration and initation of 'TimerSession'
    @StateObject private var timerSession : TimerSession = TimerSession()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(ddkModel)
                .environmentObject(timerSession)
                .environmentObject(store)
        }
    }
}

