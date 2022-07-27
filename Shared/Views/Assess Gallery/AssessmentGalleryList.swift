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
        .listStyle(.automatic)
    }
    
    @ScaledMetric var size: CGFloat = 1
    
    // List Row
    func button(_ type: AssessmentType) -> some View {
        Button {
            assessmentSelection = type
            triggerHapticFeedbackSuccess()
        } label: {
            AssessmentListRow(type: type, assessmentSettingsSelection: $assessmentSettingsSelection)
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
