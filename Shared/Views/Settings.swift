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
    @AppStorage("default_assessment_style") var defaultAssessmentType : AssessType = .timed
    @AppStorage("show_decimal_timer") var showDecimalOnTimer : Bool = true
    
    var body: some View {
        Form {
            Section(header: Text("User preferences")) {
                Picker("Default Assessment Style", selection: $defaultAssessmentType) {
                    ForEach([AssessType.timed, AssessType.count], id: \.self) {
                        Text("\($0.label)")
                            .tag($0)
                    }
                }
                
                Stepper("Countdown Time: \(countdown) \(countdown == 1 ? "second" : "seconds")", value: $countdown, in: 0...60)

                Toggle("Show Decimal on Timer", isOn: $showDecimalOnTimer)
            }
            Section {
                Button("Reset Preferences") {
                    showResetConfirmationAlert = true
                }.foregroundColor(.red)
            }
            
            if UIDevice.current.userInterfaceIdiom == .phone {
                Section(header: Text("Support:")) {
                    if !store.supportProductOptions.isEmpty {
                        ForEach(store.supportProductOptions, id: \.self) { product in
                            NavigationLink(destination: SupportTheDev(product: [product])) {
                                Text("Buy the developer a \(product.localizedTitle) \(store.getEmoji(id: product.productIdentifier))")
                                    .foregroundColor(.accentColor)
                            }
                        }
                    } else {
                        Text("No Support Options Currently Available")
                            .font(.footnote)
                    }
                }
            }
            
            Section(header: Text(getAppCurrentVersionNumber())) {
                
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
        return "Made with ❤️ \(versionStr) (\(buildStr))"
    }
    
    var resetAlert: Alert {
        Alert(
            title: Text("Reset Preferences"),
            message: Text("Are you sure you want to reset all preferences?"),
            primaryButton: .cancel(Text("Cancel")),
            secondaryButton: .destructive(Text("Reset"), action: resetPreferences)
        )
    }
    
    func resetPreferences() {
        countdown = 3
        model.currentlySelectedTimerLength = 10
        defaultAssessmentType = .timed
        heartrate = false
        showDecimalOnTimer = true
        model.resetTimed()
        model.resetCount()
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}
