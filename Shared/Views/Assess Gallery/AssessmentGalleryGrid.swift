//
//  AssessmentGalleryGrid.swift
//  AssessmentGalleryGrid
//
//  Created by Collin Dunphy on 7/17/21.
//

import SwiftUI

struct AssessmentGalleryGrid: View {
    
    @Binding var assessmentSelection         : AssessmentType?
    @Binding var assessmentSettingsSelection : AssessmentType?
    
    var body: some View {
        ScrollView {
            LazyVGrid(
                columns: [
                    GridItem(.adaptive(minimum: 170))
                ],
                alignment: .trailing,
                spacing: 12
            ) {
                ForEach(AssessmentType.allCases) { type in
                    
                    Button {
                        triggerHapticFeedbackSuccess()
                        assessmentSelection = type
                    } label: {
                        
                        VStack(alignment: .leading) {
                         
                            HStack {
                                Image(systemName: type.icon)
                                    .font(.title)
                                    .padding(.bottom)
                                
                                Spacer()
                            }
                            
                            Text(type.title)
                                .font(.headline)
                                .lineLimit(1)
                            
                            Text("53 assessments")
                                .font(.caption)
                        }
                        .foregroundColor(.white)
                        .padding(10)
                        .background(
                            //TODO: make this a gradient
                            type.color,
                            in: RoundedRectangle(cornerRadius: 10)
                        )
                        
                    }
                    .buttonStyle(.plain)
                    .contextMenu {
                        AssessmentGalleryContextMenuItems(
                            type: type,
                            assessmentSettingsSelection: $assessmentSettingsSelection
                        )
                    }
                }
            }.padding(.horizontal)
        }
    }
    
    func triggerHapticFeedbackSuccess() {
        #if os(iOS)
        let hapticFeedback = UINotificationFeedbackGenerator()
        hapticFeedback.notificationOccurred(.success)
        #endif
    }
}

struct AssessmentGalleryGrid_Previews: PreviewProvider {
    static var previews: some View {
        AssessmentGalleryGrid(
            assessmentSelection: .constant(nil),
            assessmentSettingsSelection: .constant(nil)
        )
    }
}



