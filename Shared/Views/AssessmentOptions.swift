//
//  AssessmentOptions.swift
//  AssessmentOptions
//
//  Created by Collin Dunphy on 7/18/21.
//

import SwiftUI

struct AssessmentOptions: View {
    
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var model : DDKModel
    
    @EnvironmentObject var hr : HeartRateAssessment
    
    @AppStorage("countdown_length") var countdown :             Int = 3
    @AppStorage("show_decimal_timer") var showDecimalOnTimer :  Bool = true
    @AppStorage("show_heartrate_stats") var heartRate :         Bool = false
    @AppStorage(StorageKeys.Timed.timerLength) var duration:    Int = 10
    
    var type : AssessmentType
    
    // MARK: - Form
    var form: some View {
        Form {
            Section {
//                Text(hr.title)
            }
            
            Section {
                Toggle(
                    "\(Image(systemName: "star.fill")) Favorite",
                    isOn: Binding<Bool>(
                        get: {
                            model.assessmentTypeIsFavorite(type)
                        },
                        set: { newValue in
                            model.toggleFavoriteStatus(type)
                        }
                    )
                )
            }
            
            Section("Duration") {
                Picker("Set the Seconds", selection: $duration) {
                    ForEach(1...60, id: \.self) {
                        Text("\($0)").tag($0)
                    }
                }.pickerStyle(.inline)
            }
            
            Section {
                Stepper(
                    "Countdown Time: \(countdown) \(countdown == 1 ? "second" : "seconds")",
                    value: $countdown,
                    in: 0...60
                )
                
                Toggle("Show Decimal on Timer", isOn: $showDecimalOnTimer)
            }
            
            Section {
                Toggle("Show BPM vs BPS", isOn: $heartRate)
            }
            
        }
    }
    
    // MARK: - Body
    var body: some View {
        form
            .navigationTitle(type.title)
            .navigationBarTitleDisplayMode(.inline)
        
        // Toolbar
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(
                        "Done",
                        role: .destructive,
                        action: { dismiss() }
                    )
                }
                
            }
    }
}

struct AssessmentOptions_Previews: PreviewProvider {
    static var previews: some View {
        AssessmentOptions(type: .timed)
    }
}
