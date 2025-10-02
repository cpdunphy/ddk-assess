//
//  AppMobileNavigation.swift
//  Diadochokinetic Assess
//
//  Created by Collin Dunphy on 9/24/20.
//

import Combine
import SwiftUI

struct AppMobileNavigation: View {

    @State private var tabSelection: NavigationItem = .assess

    var body: some View {
        TabView(selection: $tabSelection) {
            Tab("Assess", systemImage: "hand.tap", value: NavigationItem.assess) {
                NavigationStack {
                    AssessmentGalleryScreen()
                }
            }

            Tab("History", systemImage: "tray.full", value: NavigationItem.history) {
                NavigationStack {
                    HistoryScreen()
                }
            }

            Tab("Settings", systemImage: "gearshape", value: NavigationItem.settings) {
                NavigationStack {
                    SettingsScreen()
                }
            }
        }
    }
}
