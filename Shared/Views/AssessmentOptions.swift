//
//  AssessmentOptions.swift
//  AssessmentOptions
//
//  Created by Collin Dunphy on 7/18/21.
//

import SwiftUI

enum HeartRateDisplayUnit : String, Codable, CaseIterable, Identifiable {
    case bpm = "BPM"
    case bps = "BPS"
    
    var id: String {
        self.rawValue
    }
}

struct AssessmentOptions: View {
    
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var ddk : DDKModel
    
    @EnvironmentObject var timed : TimedCountingAssessment
    @EnvironmentObject var count : CountingAssessment
    @EnvironmentObject var hr : HeartRateAssessment
    
    @AppStorage("countdown_length") var countdown :             Int = 3
    @AppStorage("show_decimal_timer") var showDecimalOnTimer :  Bool = true
    @AppStorage("heart_rate_unit") var heartRate :              String = "BPM"
    @AppStorage(StorageKeys.Timed.timerLength) var duration:    Int = 10
    
    var type : AssessmentType
    
    var model : Assessment {
        switch type {
        case .timed:
            return timed
        case .count:
            return count
        case .heartRate:
            return hr
        }
    }
    
    // MARK: - Form
    var form: some View {
        AssessmentOptionsForm {
            Section {
                Toggle(
                    "\(Image(systemName: "star.fill")) Favorite",
                    isOn: Binding<Bool>(
                        get: {
                            ddk.assessmentTypeIsFavorite(type)
                        },
                        set: { newValue in
                            ddk.toggleFavoriteStatus(type)
                        }
                    )
                )
            }
            
            Section("Duration") {
                Picker("Set the Seconds", selection: $duration) {
                    ForEach(1...60, id: \.self) {
                        Text("\($0)").tag($0)
                    }
                }.pickerStyle(.wheel)
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
                Picker("Display Unit", selection: $heartRate) {
                    ForEach(HeartRateDisplayUnit.allCases) {
                        Text($0.rawValue).tag($0)
                    }
                }
            }
        }
    }
    
    // MARK: - Body
    var body: some View {
        form
            .navigationTitle(model.title)
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


struct AssessmentOptionsForm<Content:View> : View {
    
    var content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        Form {
            content
        }
    }
}
