//
//  ContentView.swift
//  Diadochokinetic Assess
//
//  Created by Collin on 12/1/19.
//  Copyright © 2019 Ballygorey Apps. All rights reserved.
//

import SwiftUI



struct TabBarViewController: View {
    @State var selection: Int = 2
    @EnvironmentObject var timerSession: TimerSession
    @ObservedObject var productsStore : ProductsStore
    @State var showOnboardingScreen = defaults.bool(forKey: showOnboardingKey)
    var body: some View {
        ZStack {
            if showOnboardingScreen {
                OnboardingScreen(showOnboardingScreen: $showOnboardingScreen)
            } else {
                TabView(selection: $selection) {
                
                TimedTapView().environmentObject(timerSession)
                        .tabItem {
                            VStack {
                                Image(systemName: "timer")
                                    .imageScale(.large)
                                Text("Timer")
                            }
                    }
                    .tag(0)
                    
                    UntimedTapView().environmentObject(timerSession)
                        .tabItem {
                            VStack {
                                Image(systemName: "stopwatch.fill")
                                    .imageScale(.large)
                                Text("Count")
                            }
                    }
                    .tag(1)
                    
                    TapHistoryList().environmentObject(timerSession)
                        .tabItem {
                            VStack {
                                Image(systemName: "book.fill")
                                    .imageScale(.large)
                                Text("History")
                            }
                    }
                    .tag(2)
                }
                .edgesIgnoringSafeArea(.top)
                .accentColor(Color("AccentColor"))
                //.accentColor(Color(#colorLiteral(red: 0.3339039057, green: 0.7535954078, blue: 0.711665441, alpha: 1)))
            }
        }
    }
    
}

/*struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarViewController()
    }
}*/

/*struct OnboardingScreen : View {
    @Binding var showOnboardingScreen : Bool
    var body : some View {
        Button(action: {
            self.showOnboardingScreen = false
            //Set User Preference
        }) {
            Image(systemName: showOnboardingScreen ? "star.fill" : "star")
        }
    }
}
*/
