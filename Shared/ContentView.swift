//
//  ContentView.swift
//  Shared
//
//  Created by Collin Dunphy on 9/23/20.
//

import SwiftUI

struct ContentView: View {
        
    #if os(iOS)
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    #endif
        
    var body: some View {
        #if os(iOS)
        if horizontalSizeClass == .compact {
            AppMobileNavigation()
        } else {
            AppSidebarNavigation()
        }
        
        #else
        AppSidebarNavigation()
        #endif
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
