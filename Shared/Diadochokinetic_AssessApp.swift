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

// Format Time(s) to m/s/ds
func getStandardTimeDisplayString(_ time: Double) -> String {
    //https://stackoverflow.com/questions/35215694/format-timer-label-to-hoursminutesseconds-in-swift/35215847
    //https://stackoverflow.com/questions/52332747/what-are-the-supported-swift-string-format-specifiers/52332748
    
    let minutes = Int(time) / 60 % 60
    let seconds = Int(time) % 60
    let deciseconds = time - Double(Int(time))
    var decisecondsFullStr = "\(Double(round(10*deciseconds)/10))"
    decisecondsFullStr.remove(at: decisecondsFullStr.startIndex)
    return String(format:"%02i:%02i%3$@", minutes, seconds, decisecondsFullStr)
}
