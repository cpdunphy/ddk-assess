//
//  AssessmentGalleryGrid.swift
//  AssessmentGalleryGrid
//
//  Created by Collin Dunphy on 7/17/21.
//

import SwiftUI

struct AssessmentGalleryGrid: View {
    
    @EnvironmentObject var model : DDKModel
    
    @Binding var assessmentSelection         : AssessmentType?
    @Binding var assessmentSettingsSelection : AssessmentType?
    
    var columns = [
        GridItem(.adaptive(minimum: 170))
    ]
    
    var body: some View {
        ScrollView {
            VStack {
                
                // Favorited Assessments
                if !model.isFavoriteAssessmentsEmpty {
                    VStack(alignment: .leading) {
                        Text("Favorites".uppercased())
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.leading)
                        
                        LazyVGrid(
                            columns: columns,
                            spacing: 12
                        ) {
                            ForEach(
                                AssessmentType.allCases.filter {
                                    model.favoriteAssessments.contains($0.id)
                                }
                            ) { type in
                                button(type)
                            }
                        }
                        
                        Divider()
                            .padding(.vertical, 6)
                    }
                }
                
                // Not Favorited Assessments
                LazyVGrid(
                    columns: columns,
                    spacing: 12
                ) {
                    ForEach(
                        AssessmentType.allCases.filter {
                            !model.favoriteAssessments.contains($0.id)
                        }
                    ) { type in
                        button(type)
                    }
                }
            }.padding(.horizontal)
        }
    }
    
    func button(_ type: AssessmentType) -> some View {
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



