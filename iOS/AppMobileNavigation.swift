//
//  AppMobileNavigation.swift
//  Diadochokinetic Assess
//
//  Created by Collin Dunphy on 9/24/20.
//

import SwiftUI
import Combine

struct AppMobileNavigation: View {

    @EnvironmentObject var model : DDKModel
    @Environment(\.presentationMode) var presenationMode

    @State private var historyModalState : Bool = false
    @Binding var mobiletabSelection : NavigationItem
    
    
    var body: some View {
        TabView(selection: $mobiletabSelection) {
            NavigationView {
                assess
            }
            .tabItem { NavigationItem.assess.label }
            .tag(NavigationItem.assess)
            
            NavigationView {
                RecordHistoryList()
            }
            .tabItem { NavigationItem.history.label }
            .tag(NavigationItem.history)

            NavigationView {
                Settings()
            }
            .tabItem { NavigationItem.settings.label }
            .tag(NavigationItem.settings)
        }

    }

    var assess : some View {
        AssessScreen()
            .background(
                Color(.systemGroupedBackground)
                    .edgesIgnoringSafeArea(.all)
            )
            .toolbar {
                ToolbarItem(placement: ToolbarItemPlacement.navigationBarTrailing) {
                    AssessmentPicker(type: $model.assessType)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Assess")

    }
}

struct AssessScreen : View {
    
    @EnvironmentObject var model : DDKModel
    @EnvironmentObject var timerSession : TimerSession
    
    var body : some View {
        VStack(spacing: 20) {
            StatsDisplay()
                .layoutPriority(1)
            TapButton()
                .layoutPriority(1)
        }
        .padding(.horizontal, 20)
        .padding([.top, .bottom], 20)
    }
}



