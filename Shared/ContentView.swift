//
//  ContentView.swift
//  Shared
//
//  Created by Collin Dunphy on 9/23/20.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var model : DDKModel
    @State private var type : AssessType = .timed
    
    #if os(iOS)
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    #endif
    
    @State private var mobiletabSelection : NavigationItem = .assess
    @State private var sidebarSelection : Set<NavigationItem> = [.assess]
    
    var body: some View {
        #if os(iOS)
        if horizontalSizeClass == .compact {
            AppMobileNavigation(mobiletabSelection: $mobiletabSelection)
        } else {
            AppSidebarNavigation(sidebarSelection: $sidebarSelection)
        }
        
        #else
        AppSidebarNavigation(sidebarSelection: $sidebarSelection)
        #endif
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
