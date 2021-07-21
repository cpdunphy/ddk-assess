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
    
    var body: some View {
        List {
            if !AssessmentType.allCases.filter { model.favoriteAssessments.contains($0.id)
            }.isEmpty {
                Section("Favorites") {
                    ForEach(
                        AssessmentType.allCases.filter { model.favoriteAssessments.contains($0.id)
                        }
                    ) { type in
                        button(type)
                    }
                }
                
            }
            
            Section {
                ForEach(
                    AssessmentType.allCases.filter { !model.favoriteAssessments.contains($0.id)
                    }
                ) { type in
                    button(type)
                }
            }
        }
    }
    
    func button(_ type: AssessmentType) -> some View {
        Button {
            assessmentSelection = type
        } label: {
            HStack {
                AssessmentGalleryIcon(type: type)
                    .padding(.trailing, 4)
                
                VStack(alignment: .leading) {
                    Text(type.title)
                        .font(.headline)
                    Text("53 assessments")
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
                
                Spacer()
            }
        }
        .contextMenu {
            AssessmentGalleryContextMenuItems(
                type: type,
                assessmentSettingsSelection: $assessmentSettingsSelection
            )
        }
        .swipeActions(edge: .leading) {
            Button {
                print("Mark as favorite")
            } label: {
                Label("Favorite", systemImage: "star")
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
