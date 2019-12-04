//
//  Settings.swift
//  Count-My-Taps
//
//  Created by Collin on 11/30/19.
//  Copyright © 2019 Ballygorey Apps. All rights reserved.
//

import SwiftUI

struct Settings: View {
    @State private var countdownCount = defaults.integer(forKey: countdownKey)
    @EnvironmentObject var timerSession : TimerSession
    var resetAlert: Alert {
        Alert(
            title: Text("Reset Preferences"),
            message: Text("Are you sure you want to reset all preferences?"),
            primaryButton: .cancel(Text("Cancel")),
            secondaryButton: .destructive(Text("Reset"), action: {
                self.resetOnClose = false
                self.presentSettingsModal = false
                defaults.set(3, forKey: countdownKey)
                defaults.set(true, forKey: secondsKey)
            })
        )
    }
    @State var resetOnClose = true
    @State var showResetConf: Bool = false
    @Binding var presentSettingsModal : Bool
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("User Preferences")) {
                    Stepper(
                        onIncrement: {
                            if self.countdownCount < 60 {
                                self.countdownCount += 1
                                UserDefaults.standard.set(self.countdownCount, forKey: countdownKey)
                            }
                    },
                        onDecrement: {
                            if self.countdownCount > 0 {
                                self.countdownCount -= 1
                                UserDefaults.standard.set(self.countdownCount, forKey: countdownKey)
                            }
                    }) {
                        Text("Countdown Time: \(self.countdownCount) \(self.countdownCount == 1 ? "second" : "seconds")")
                    }
                }
                Section {
                    Button(action: {
                        self.showResetConf = true
                    }) {
                        Text("Reset Preferences")
                            .foregroundColor(.red)
                    }
                }
            }
            .alert(isPresented: $showResetConf) {
                resetAlert
            }
            .navigationBarTitle(Text("Settings"))
        }
    }
}

//struct Settings_Previews: PreviewProvider {
//    static var previews: some View {
//        Settings()
//    }
//}
