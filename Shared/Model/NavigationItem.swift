//
//  NavigationItem.swift
//  Diadochokinetic Assess
//
//  Created by Collin Dunphy on 1/6/21.
//

import Foundation
import SwiftUI

enum NavigationItem {
    case assess, history, support, settings
}

extension NavigationItem {
    var label: some View {
        switch self {
        case .assess:
            return Label("Assess", systemImage: "hand.tap.fill")
        case .history:
            return Label("History", systemImage: "tray.full.fill")
        case .support:
            return Label("Support", systemImage: "heart.fill")
        case .settings:
            return Label("Settings", systemImage: "gearshape.fill")
        }
    }
}

extension NavigationItem {
    var title : String {
        switch self {
        case .assess:
            return "Assess"
        case .history:
            return "History"
        case .support:
            return "Support"
        case .settings:
            return "Settings"
        }
    }
}
