//
//  NavigationItem.swift
//  Diadochokinetic Assess
//
//  Created by Collin Dunphy on 1/6/21.
//

import Foundation
import SwiftUI

enum NavigationItem {
    case assess, history, settings
}

extension NavigationItem {
    var label: some View {
        switch self {
        case .assess:
            return Label("Assess", systemImage: "hand.tap")
        case .history:
            return Label("History", systemImage: "tray.full")
        case .settings:
            return Label("Settings", systemImage: "gearshape")
        }
    }
}

extension NavigationItem {
    var title: String {
        switch self {
        case .assess:
            return "Assess"
        case .history:
            return "History"
        case .settings:
            return "Settings"
        }
    }
}
