//
//  AssessmentGalleryType.swift
//  AssessmentGalleryType
//
//  Created by Collin Dunphy on 7/17/21.
//

import Foundation
import SwiftUI

enum AssessmentGalleryType: String, Identifiable, CaseIterable {

    case grid, list
    
    var label: some View {
        switch self {
        case .grid:
            return Label("Icons", systemImage: "square.grid.2x2")
        case .list:
            return Label("List", systemImage: "list.bullet")
        }
    }
    
    var id: String {
        return self.rawValue
    }
}
