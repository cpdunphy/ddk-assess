//
//  AssessmentGalleryGrid.swift
//  AssessmentGalleryGrid
//
//  Created by Collin Dunphy on 7/17/21.
//

import SwiftUI

struct AssessmentGalleryGrid: View {
    
    @EnvironmentObject var ddk : DDKModel
    
    @Binding var assessmentSelection         : AssessmentType?
    @Binding var assessmentSettingsSelection : AssessmentType?
    
    var columns = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    var body: some View {
        ScrollView {
            VStack {
                
                // Favorited Assessments
                if !ddk.isFavoriteAssessmentsEmpty {
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
                                    ddk.favoriteAssessments.contains($0.id)
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
                            !ddk.favoriteAssessments.contains($0.id)
                        }
                    ) { type in
                        button(type)
//                        Rectangle()
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
                
                Image(systemName: type.icon)
                    .font(.title)
                    .symbolVariant(.fill)
                    .padding(.bottom, 6)

                Spacer(minLength: 0)
                
                Text(type.title)
                    .font(.headline)
                    .lineSpacing(6)
                    .lineLimit(2)
                
                Text(ddk.assessCountDescription(type))
                    .font(.caption)
                    .truncationMode(.tail)
                    .lineLimit(1)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, minHeight: 85, maxHeight: .infinity, alignment: .leading)
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



