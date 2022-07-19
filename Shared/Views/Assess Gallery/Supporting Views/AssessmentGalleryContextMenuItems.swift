//
//  AssessmentGalleryContextMenuItems.swift
//  AssessmentGalleryContextMenuItems
//
//  Created by Collin Dunphy on 7/17/21.
//

import SwiftUI

struct AssessmentGalleryContextMenuItems: View {
    
    @EnvironmentObject var model : DDKModel
    
    var type: AssessmentType
    
    @Binding var assessmentSettingsSelection : AssessmentType?
    
    var body: some View {
        Group {
//            Button {
//                withAnimation(.easeInOut(duration: 0.25)) {
//                    model.toggleFavoriteStatus(type)
//                }
//            } label: {
//                if model.assessmentTypeIsFavorite(type) {
//                    Label("Unfavorite", systemImage: "star.slash")
//                } else {
//                    Label("Favorite", systemImage: "star")
//                }
//                
//            }
            
            Button {
                assessmentSettingsSelection = type
            } label: {
                Label("Options", systemImage: "ellipsis.circle")
            }
        }
    }
}

struct AssessmentGalleryContextMenuItems_Previews: PreviewProvider {
    static var previews: some View {
        AssessmentGalleryContextMenuItems(
            type: .timed,
            assessmentSettingsSelection: .constant(nil)
        )
    }
}
