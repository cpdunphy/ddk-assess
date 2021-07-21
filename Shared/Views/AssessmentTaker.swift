//
//  AssessmentTaker.swift
//  AssessmentTaker
//
//  Created by Collin Dunphy on 7/18/21.
//

import SwiftUI

struct AssessmentTaker: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State var assessmentSettingsSelection : AssessmentType? = nil
    
    var type : AssessmentType
    
    var body: some View {
        VStack(spacing: 0) {
            navigationBar
                .background(.bar)
            
            VStack(spacing: 16) {
                
                StatsDisplay()
                    .layoutPriority(1)
                TapButton()
                    .layoutPriority(1)
                
            }.padding(16)
            
        }
        .background(Color(.systemGroupedBackground))
        .sheet(item: $assessmentSettingsSelection) { type in
            NavigationView {
                AssessmentOptions(type: type)
            }
        }
    }
    
    var navigationBar : some View {
        VStack(spacing: 0) {
            
            HStack {
                
                AssessmentGalleryIcon(type: type)
                
                VStack(alignment: .leading) {
                    
                    Text(type.title)
                        .font(.title2 )
                        .fontWeight(.bold)
                    
                    Text("53 assessments")
                        .foregroundColor(.secondary)
                        .font(.caption)
                    
                }
                
                Spacer()
                
                HStack(spacing: 16) {
                    Button {
                        assessmentSettingsSelection = type
                    } label: {
                        Label("Options", systemImage: "ellipsis.circle")
                            .imageScale(.large)
                            .labelStyle(.iconOnly)
                            .font(.title3)
                    }
                    
                    Button {
                        dismiss()
                    } label: {
                        Label("Close", systemImage: "xmark.circle.fill")
                            .symbolRenderingMode(.hierarchical)
                            .foregroundColor(.gray)
                            .labelStyle(.iconOnly)
                            .imageScale(.large)
                            .font(.title3)
                    }
                }
            }.padding()
            
            Divider()
                .background(.ultraThickMaterial)
        }
        
    }
}

struct AssessmentTaker_Previews: PreviewProvider {
    static var previews: some View {
        AssessmentTaker(type: .timed)
    }
}
