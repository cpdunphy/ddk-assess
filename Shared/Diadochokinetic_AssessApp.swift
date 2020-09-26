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
    
//    @State private var assessType : AssessType = .timed
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(ddkModel)
                .environmentObject(timerSession)
                .environmentObject(store)
//                .environment(\.assessType, $assessType.wrappedValue)
        }
    }
}

//struct AssessTypeEnvironmentKey: EnvironmentKey {
//    static let defaultValue: AssessType = .timed
//}
//
//extension EnvironmentValues {
//    var assessType: AssessType {
//        get {
//            self[AssessTypeEnvironmentKey]
//        }
//        set {
//            self[AssessTypeEnvironmentKey] = newValue
//        }
//    }
//}
