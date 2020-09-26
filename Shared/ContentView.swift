//
//  ContentView.swift
//  Shared
//
//  Created by Collin Dunphy on 9/23/20.
//

import SwiftUI

struct ContentView: View {
//    @EnvironmentObject var model : DDKModel
    @State private var type : AssessType = .timed
    
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


//extension Timer {
//    static let timerLoop = Timer.publish(every: 0.1, on: .main, in: .default)
//        .autoconnect()
//        .sink(receiveValue: { time in
//            print(Thread.isMainThread)
//            self.currentDateTime = time
//        })
//}



/*
 NavigationView {
     Text("Hello, world!")
         .padding()
         .toolbar {
             ToolbarItem(id: "Assessment Selector", placement: ToolbarItemPlacement.principal, showsByDefault: true) {
                 Picker("What type of assessment?", selection: $type) {
                     Text(AssessType.timed.label).tag(AssessType.timed)
                     Text(AssessType.count.label).tag(AssessType.count)
                 }.pickerStyle(SegmentedPickerStyle())
                 .frame(width: UIScreen.main.bounds.width * 0.9)
             }
         }
 }
 */
