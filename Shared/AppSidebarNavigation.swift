//
//  AppSidebarNavigation.swift
//  Diadochokinetic Assess
//
//  Created by Collin Dunphy on 9/24/20.
//

import SwiftUI

struct AppSidebarNavigation: View {

    @EnvironmentObject var model : DDKModel
    
    @State private var sidebarSelection : Set<NavigationItem> = [.assess]
    
    var body: some View {
        NavigationView {
            #if os(macOS)
            /// Brings support to macOS, setting a limit on the extent to which it can expand/contract. Also adds a 'toggle to open/close the sidebar.
            sidebar
                .frame(minWidth: 100, idealWidth: 150, maxHeight: .infinity)
                .toolbar {
                    ToolbarItem(placement: .navigation) {
                        sidebarToggleButton
                    }
                }
            #else
            sidebar
            #endif
            
            
            /// Applies a conditional modifier to devices not on macOS, setting the NavBar Display Mode to '.inline'
            #if os(macOS)
            AssessScreen()
            #else
            AssessScreen()
                .navigationBarTitleDisplayMode(.inline)
            #endif
        }
    }
    
    /// Sidebar for use in macOS & iPadOS
    var sidebar : some View {
        List(selection: $sidebarSelection) {
            NavigationLink(destination: AssessScreen()) {
                NavigationItem.assess.label
            }.tag(NavigationItem.assess)
            
            NavigationLink(destination: HistoryScreen()) {
                NavigationItem.history.label
            }.tag(NavigationItem.history)
            
            NavigationLink(destination: SupportTheDev()) {
                NavigationItem.support.label
            }.tag(NavigationItem.support)
            
            /// SettingsScreen is only in iOS because macOS has its own settings configuration. TODO: Needs to be implemented through 'ContentView'
            #if os(iOS)
            NavigationLink(destination: SettingsScreen()) {
                NavigationItem.settings.label
            }.tag(NavigationItem.settings)
            #endif
        }
        .listStyle(SidebarListStyle())
        .navigationTitle("DDK")
    }
    
    
    
    /// macOS Sidebar Toggle
    #if os(macOS)
    var sidebarToggleButton : some View {
        Button(action: toggleSidebar) {
            Image(systemName: "sidebar.left")
                .font(.title)
        }
    }
    
    private func toggleSidebar() {
        NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
    }
    #endif
    
}
