//
//  ContentView.swift
//  Diadochokinetic Assess
//
//  Created by Collin on 12/1/19.
//  Copyright © 2019 Ballygorey Apps. All rights reserved.
//

import SwiftUI

struct TabBarViewController: View {
    @State var selection: Int = 0
    @EnvironmentObject var timerSession: TimerSession
    @ObservedObject var productsStore : ProductsStore
    @State var showOnboardingScreen = defaults.bool(forKey: showOnboardingKey)
    @State var presentSettingsModal: Bool = false
    var helpAlert: Alert {
        Alert(
            title: Text(promotionalTextTitle),
            message: Text("You have assesed a patient's Diadochokinetic Rate \(userTotalCount) times. If you like the app, please consider supporting the developer."),
            primaryButton: .cancel(Text("Yeah I'll Support! 🥰"), action: {
                print("Helping")
                self.timerSession.setLogCount(num: 0)
                self.selection = 2
                self.presentSettingsModal = true
            }),
            secondaryButton: .destructive(Text("No, I don't want to help"), action: {
                self.timerSession.setLogCount(num: 0)
            })
        )
    }

    var body: some View {
        ZStack {
            if showOnboardingScreen {
                OnboardingScreen(showOnboardingScreen: $showOnboardingScreen)
            } else {
                ZStack {

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
                        
                        TapHistoryList(presentSettingsModal: $presentSettingsModal).environmentObject(timerSession)
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
                    
                    /*if timerSession.logCount >= 3 {//75 {
                       
                        SupportTheDevScreen(presentSettingsModal: $presentSettingsModal, selection: $selection)
                    }*/
                    //.accentColor(Color(#colorLiteral(red: 0.3339039057, green: 0.7535954078, blue: 0.711665441, alpha: 1)))
                }.alert(isPresented: $timerSession.showSupportAd) {
                    helpAlert
                }

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

struct SupportTheDevScreen : View {
    @EnvironmentObject var timerSession: TimerSession
    @Binding var presentSettingsModal : Bool
    @Binding var selection: Int
    var body : some View {
        ZStack {
            Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 0.33)).edgesIgnoringSafeArea(.all)
            ZStack {
                ZStack(alignment: .topTrailing) {
                    Rectangle()
                        .cornerRadius(10)
                        .foregroundColor(Color("ddkColor"))
                        .shadow(radius: 3)
                    Button(action: {
                        self.timerSession.setLogCount(num: 0)
                    }) {
                        XButton()
                    }
                    .frame(width: 40, height: 40)
                    .offset(CGSize(width: 15, height: -15))
                }
                VStack {
                    Button(action: {
                        print("Helping")
                        self.timerSession.setLogCount(num: 0)
                        self.selection = 2
                        self.presentSettingsModal = true
                    }) {
                        Text("Help Me")
                    }
                }
            }.frame(width: Screen.width * 0.7, height: Screen.height * 0.4)
        }
    }
    
    struct XButton : View {
        var body : some View {
            ZStack {
                Circle()
                    .foregroundColor(.red)
                Text("X")
                    .foregroundColor(.white)
            }
        }
    }
}
