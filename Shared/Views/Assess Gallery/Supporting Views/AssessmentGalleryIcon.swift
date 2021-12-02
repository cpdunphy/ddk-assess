//
//  AssessmentGalleryIcon.swift
//  AssessmentGalleryIcon
//
//  Created by Collin Dunphy on 7/17/21.
//

import SwiftUI

struct AssessmentGalleryIcon: View {
    
    var type : AssessmentType

    var body: some View {
        Image(systemName: type.icon)
            .font(.title3)
            .imageScale(.large)
            .symbolVariant(.fill)
            .foregroundColor(.white)
            .padding(10)
            .background(
                type.color,
                in: RoundedRectangle(cornerRadius: 8)
            )
            .padding(2)
            
//            .overlay(
//                RoundedRectangle(cornerRadius: 10)
//                    .stroke(.ultraThickMaterial, lineWidth: 6)
//                    .cornerRadius(8)
//            )
    }
}

struct AssessmentGalleryIcon_Previews: PreviewProvider {
    static var previews: some View {
        AssessmentGalleryIcon(type: .timed)
            .previewLayout(.sizeThatFits)
    }
}
