//
//  AppSidebarNavigation.swift
//  Diadochokinetic Assess
//
//  Created by Collin Dunphy on 9/24/20.
//

import SwiftUI

struct AppSidebarNavigation: View {
    @EnvironmentObject var model : DDKModel
    
    @Binding var sidebarSelection : Set<NavigationItem>
    
    var body: some View {
        NavigationView {
            #if os(macOS)
            sidebar
                .frame(minWidth: 100, idealWidth: 150, maxHeight: .infinity)
                .toolbar {
                    ToolbarItem(placement: .navigation) {
                        Button(action: toggleSidebar) {
                            Image(systemName: "sidebar.left")
                                .font(.title)
                        }
                    }
                    
                }
            #else
            sidebar
            #endif
            layout
        }
    }
    
    var layout: some View {
        VStack(spacing: 20) {
            StatsDisplay()
            TapButton()
        }
        .padding(.top, 20)
        .padding([.horizontal, .bottom], 20)
//        .background(
//            Color(.systemGroupedBackground)
//                .edgesIgnoringSafeArea(.all)
//        )
        .toolbar {
            AssessmentPicker(type: $model.assessType)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Assess")
    }
    
    private func toggleSidebar() {
        #if os(iOS)
        #else
        NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
        #endif
    }
    
    
    var sidebar : some View {
        List(selection: $sidebarSelection) {
            NavigationLink(destination: layout) {
                NavigationItem.assess.label
            }.tag(NavigationItem.assess)
            NavigationLink(destination: RecordHistoryList()) {
                NavigationItem.history.label
            }.tag(NavigationItem.history)
            NavigationLink(destination: SupportTheDev()) {
                NavigationItem.support.label
            }.tag(NavigationItem.support)
            NavigationLink(destination: Settings()) {
                NavigationItem.settings.label
            }.tag(NavigationItem.settings)
        }.listStyle(SidebarListStyle())
        .navigationTitle("DDK")
    }
}
