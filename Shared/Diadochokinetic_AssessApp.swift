//
//  Diadochokinetic_AssessApp.swift
//  Shared
//
//  Created by Collin Dunphy on 9/23/20.
//

import SwiftUI

@main
struct Diadochokinetic_AssessApp: App {
    
    @StateObject private var ddkModel : DDKModel = DDKModel()
    @StateObject private var store : Store = Store()
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

enum NavigationItem {
    case assess, history, support, settings
}

extension NavigationItem {
    var label: some View {
        switch self {
        case .assess:
            return Label("Assess", systemImage: "hand.tap.fill")
        case .history:
            return Label("History", systemImage: "tray.full.fill")
        case .support:
            return Label("Support", systemImage: "heart.fill")
        case .settings:
            return Label("Settings", systemImage: "gearshape.fill")
        }
    }
}



