//
//  Settings.swift
//  Diadochokinetic Assess
//
//  Created by Collin Dunphy on 9/29/20.
//

import SwiftUI

struct Settings: View {
    
    @EnvironmentObject var model : DDKModel
    @EnvironmentObject var store : Store
    
    @State private var showResetConfirmationAlert : Bool = false
    
    @AppStorage("countdown_length") var countdown : Int = 3
    @AppStorage("show_heartrate_stats") var heartrate : Bool = false
    
    
    var body: some View {
        Form {
            Section(header: Text("User preferences")) {
//                Picker("Default Assessment Style", selection: $model.defaultAssessmentType) {
//                    ForEach([AssessType.timed, AssessType.count], id: \.self) {
//                        Text("\($0.label)")
//                            .tag($0.label)
//                    }
//                }.onChange(of: model.defaultAssessmentType) { (item) in
//                    print("Change of \(item)")
//                }
                Stepper("Countdown Time: \(countdown) \(countdown == 1 ? "second" : "seconds")", value: $countdown, in: 0...60)
                    .onChange(of: countdown, perform: { value in
                        print("Change of Countdown: \(value)")
                    })
            }
            Section {
                Button("Reset Preferences") {
                    showResetConfirmationAlert = true
                }.foregroundColor(.red)
            }

            Section(header: Text("Products:"), footer: Text(getAppCurrentVersionNumber())) {
                if !store.supportProductOptions.isEmpty {
                    ForEach(store.supportProductOptions, id: \.self) { product in
                        NavigationLink(destination: Text("Testing")) {
                            Text("Buy the developer a \(product.localizedTitle) \(store.getEmoji(id: product.productIdentifier))")
                                .foregroundColor(.accentColor)
                        }
                    }
                } else {
                    Text("No Products Currently Available")
                }
            }
            
        }
        .navigationTitle("Settings")
        .alert(isPresented: $showResetConfirmationAlert) {
            resetAlert
        }
    }
    
    func getAppCurrentVersionNumber() -> String {
        let dictionary = Bundle.main.infoDictionary!
        let version: AnyObject? = dictionary["CFBundleShortVersionString"] as AnyObject?
        let build : AnyObject? = dictionary["CFBundleVersion"] as AnyObject?
        let versionStr = version as! String
        let buildStr = build as! String
        return "Made with ❤️ \(versionStr)(\(buildStr))"
//        return nsObject as! String
    }
    
    var resetAlert: Alert {
        Alert(
            title: Text("Reset Preferences"),
            message: Text("Are you sure you want to reset all preferences?"),
            primaryButton: .cancel(Text("Cancel")),
            secondaryButton: .destructive(Text("Reset"), action: {
                countdown = 3
                model.currentlySelectedTimerLength = 10
                heartrate = false
//                self.timerSession.ResetTimedMode()
//                self.timerSession.stopUntimed()
//                defaults.set(false, forKey: showOnboardingKey)
            })
        )
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}
