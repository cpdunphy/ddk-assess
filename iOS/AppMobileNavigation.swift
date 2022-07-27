//
//  AppMobileNavigation.swift
//  Diadochokinetic Assess
//
//  Created by Collin Dunphy on 9/24/20.
//

import SwiftUI
import Combine

struct AppMobileNavigation: View {
        
    @State private var tabSelection : NavigationItem = .assess
    
    var body: some View {
        TabView(selection: $tabSelection) {
            NavigationView {
                AssessmentGalleryScreen()
            }
            .tabItem { NavigationItem.assess.label }
            .tag(NavigationItem.assess)
            
            NavigationView {
                HistoryScreen()
            }
            .tabItem { NavigationItem.history.label }
            .tag(NavigationItem.history)

            NavigationView {
                SettingsScreen()
            }
            .tabItem { NavigationItem.settings.label }
            .tag(NavigationItem.settings)
        }

    }
}
