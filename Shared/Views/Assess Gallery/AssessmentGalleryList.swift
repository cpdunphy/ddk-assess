//
//  AssessmentGalleryList.swift
//  AssessmentGalleryList
//
//  Created by Collin Dunphy on 7/17/21.
//

import SwiftUI

struct AssessmentGalleryList: View {
    
    @EnvironmentObject var model : DDKModel
    
    @Binding var assessmentSelection         : AssessmentType?
    @Binding var assessmentSettingsSelection : AssessmentType?
    
    // MARK: - Body
    var body: some View {
        List {
            
            // Favorited Assessments
            if !model.isFavoriteAssessmentsEmpty {
                Section("Favorites") {
                    ForEach(
                        AssessmentType.allCases.filter {
                            model.favoriteAssessments.contains($0.id)
                        }
                    ) { type in
                        button(type)
                    }
                } 
                
            }
            
            // Not Favorited Assessments
            Section {
                ForEach(
                    AssessmentType.allCases.filter {
                        !model.favoriteAssessments.contains($0.id)
                    }
                ) { type in
                    button(type)
                }
            }
        }
    }
    
    @ScaledMetric var size: CGFloat = 1
    
    // List Row
    func button(_ type: AssessmentType) -> some View {
        Button {
            assessmentSelection = type
            triggerHapticFeedbackSuccess()
        } label: {
            HStack {
                Image(systemName: type.icon)
                    .font(.title2)
                    .foregroundColor(.white)
                    .symbolVariant(.fill)
                    .frame(width: 45 * size, height: 45 * size)
                    .background(type.color, in: RoundedRectangle(cornerRadius: 8))
                    .padding(.trailing, 6)
                
                VStack(alignment: .leading) {
                    Text(type.title)
                        .foregroundColor(.primary)
                        .fontWeight(.medium)
                    
                    Text(model.assessCountDescription(type))
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
                
                Spacer()
                
                // Context Menu Items
                Menu {
                    AssessmentGalleryContextMenuItems(
                        type: type,
                        assessmentSettingsSelection: $assessmentSettingsSelection
                    )
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.primary)
                    // Extends the Hit-box
                        .padding([.leading])
                        .frame(maxHeight: .infinity)
                }
                
            }.padding(.vertical, 2)
        }
        
        // Context Menu
        .contextMenu {
            AssessmentGalleryContextMenuItems(
                type: type,
                assessmentSettingsSelection: $assessmentSettingsSelection
            )
        }
        
        // Swipe to Favorite
        .swipeActions(edge: .leading) {
            Button {
                model.toggleFavoriteStatus(type)
            } label: {
                if model.assessmentTypeIsFavorite(type) {
                    Label("Unfavorite", systemImage: "star.slash")
                } else {
                    Label("Favorite", systemImage: "star")
                }
            }.tint(.yellow)
        }
    }
    
    func triggerHapticFeedbackSuccess() {
#if os(iOS)
        let hapticFeedback = UINotificationFeedbackGenerator()
        hapticFeedback.notificationOccurred(.success)
#endif
    }
}

struct AssessmentGalleryList_Previews: PreviewProvider {
    static var previews: some View {
        AssessmentGalleryList(
            assessmentSelection: .constant(nil),
            assessmentSettingsSelection: .constant(nil)
        )
    }
}


struct CentreAlignedLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        Label {
            configuration.title
                .alignmentGuide(.firstTextBaseline) {
                    $0[VerticalAlignment.center]
                }
        } icon: {
            configuration.icon
                .alignmentGuide(.firstTextBaseline) {
                    $0[VerticalAlignment.center]
                }
        }
    }
}

struct ColorfulIconLabelStyle: LabelStyle {
    var color: Color
    @ScaledMetric var size: CGFloat = 1

    func makeBody(configuration: Configuration) -> some View {
        Label {
            configuration.title
                .foregroundColor(.primary)
        } icon: {
            configuration.icon
                .font(.title2)
                .symbolVariant(.fill)
                .foregroundColor(color)
        }
    }
}
