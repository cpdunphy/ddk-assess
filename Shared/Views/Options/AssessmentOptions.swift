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
        Form {
            Section {
                favoriteToggle
            }
            
            options
        }
    }
        
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
