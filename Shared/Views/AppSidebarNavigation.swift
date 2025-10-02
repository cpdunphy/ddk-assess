//
//  AppSidebarNavigation.swift
//  Diadochokinetic Assess
//
//  Created by Collin Dunphy on 9/24/20.
//

import SwiftUI

struct AppSidebarNavigation: View {

    @EnvironmentObject var model: DDKModel

    @State private var sidebarSelection: Set<NavigationItem> = [.assess]
    @State private var showSettingsModal: Bool = false

    var body: some View {
        NavigationView {

            /// Brings support to macOS, setting a limit on the extent to which it can expand/contract. Also adds a 'toggle to open/close the sidebar.
            HistoryScreen()
                .sheet(isPresented: $showSettingsModal) {
                    NavigationStack {
                        SettingsModal()
                    }
                }

            /// Applies a conditional modifier to devices not on macOS, setting the NavBar Display Mode to '.inline'
            AssessmentGalleryScreen()
                .toolbar {
                    ToolbarItemGroup(placement: ToolbarItemPlacement.navigationBarLeading) {
                        Button {
                            showSettingsModal = true
                        } label: {
                            Image(systemName: "gearshape")
                        }
                    }
                }
        }
    }

    struct SettingsModal: View {
        @EnvironmentObject var model: DDKModel

        @Environment(\.dismiss) var dismiss

        var body: some View {
            SettingsScreen()
                .environmentObject(model)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    Button("Done", action: { dismiss() })
                }
        }
    }
}
