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
    
    @EnvironmentObject var timed : TimedAssessment
    @EnvironmentObject var count : CountingAssessment
    @EnvironmentObject var hr : HeartRateAssessment
    
    var type : AssessmentType

    var model : AssessmentProtocol? {
        switch type {
        case .timed:
            return timed
        case .count:
            return count
        case .heartRate:
            return hr
        default:
            return nil
        }
    }
    
    @State private var showResetCountConf : Bool = false
    @State private var showResetConfirmationAlert : Bool = false
    
    // MARK: - Form
    var form: some View {
        Form {
//            Section {
//                favoriteToggle
//            }
            
            options
            
            Section {
                resetLogsButton    
                resetPreferencesButton
            }
        }
    }
    
    // Favorite Toggle
    var favoriteToggle : some View {
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
    
    // Reset Temp Logs Button
    var resetLogsButton : some View {
        Button(role: .destructive) {
            showResetCountConf = true
        } label: {
            Label("Reset Logs", systemImage: "clock.arrow.circlepath")
        }.foregroundColor(.red)
        .confirmationDialog(
            "Reset Logs",
            isPresented: $showResetCountConf,
            actions: {
                Button("Cancel", role: .cancel, action: { })
                
                Button("Reset", role: .destructive, action: {
                    ddk.resetTypeValue(for: type)
                })
                
            },
            message: {
                Text("Reset the number of times you've done assessments of this type")
            }
        )
    }
    
    // Reset Preferences Button
    var resetPreferencesButton : some View {
        Button {
            showResetConfirmationAlert = true
        } label: {
            Label("Reset Preferences", systemImage: "exclamationmark.arrow.circlepath")
        }.foregroundColor(.red)
        // Reset Settings Confirmation
        .confirmationDialog(
            "Reset Preferences",
            isPresented: $showResetConfirmationAlert,
            actions: {
                Button("Cancel", role: .cancel) { }
                
                Button("Reset", role: .destructive, action: model?.resetPreferences ?? {})
            },
            message: {
                Text("Are you sure you want to reset all preferences?")
            }
        )
    }
    
    // MARK: - Body
    var body: some View {
        form
            .navigationTitle(model?.title ?? "Untitled")
        #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
        #endif
        
        // Toolbar
            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(
                        "Done",
                        role: .destructive,
                        action: { dismiss() }
                    )
//                }
            }
    }
}

struct AssessmentOptions_Previews: PreviewProvider {
    static var previews: some View {
        AssessmentOptions(type: .timed)
    }
}
