//
//  AssessmentGalleryContextMenuItems.swift
//  AssessmentGalleryContextMenuItems
//
//  Created by Collin Dunphy on 7/17/21.
//

import SwiftUI

struct AssessmentGalleryContextMenuItems: View {
    
    var type: AssessmentType
    
    @Binding var assessmentSettingsSelection : AssessmentType?
    
    var body: some View {
        Group {
            Button {
                //TODO: Implement Favorites
                print(type.title)
            } label: {
                Label("Favorite", systemImage: "star")
            }
            
            Button {
                //TODO: Implement Options
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
