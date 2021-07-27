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
    
    // List Row
    func button(_ type: AssessmentType) -> some View {
        Button {
            assessmentSelection = type
        } label: {
            HStack {
                AssessmentGalleryIcon(type: type)
                    .padding(.trailing, 4)
                
                VStack(alignment: .leading) {
                    Text(type.title)
                        .foregroundColor(.primary)
                        .font(.headline)
                    
                    Text("53 assessments")
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
                
                Spacer()
                
                // Context Menu Items
                Menu {
                    AssessmentGalleryContextMenuItems(type: type, assessmentSettingsSelection: $assessmentSettingsSelection)
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.primary)
                    // Extends the Hit-box
                        .padding([.leading])
                        .frame(maxHeight: .infinity)
                }
                
            }
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
}

struct AssessmentGalleryList_Previews: PreviewProvider {
    static var previews: some View {
        AssessmentGalleryList(
            assessmentSelection: .constant(nil),
            assessmentSettingsSelection: .constant(nil)
        )
    }
}
