//
//  ContentView.swift
//  Shared
//
//  Created by Collin Dunphy on 9/23/20.
//

import SwiftUI

struct ContentView: View {

    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    var body: some View {
        if horizontalSizeClass == .compact {
            AppMobileNavigation()
        } else {
            AppSidebarNavigation()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
