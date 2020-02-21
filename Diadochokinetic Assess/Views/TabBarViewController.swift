//
//  ContentView.swift
//  Diadochokinetic Assess
//
//  Created by Collin on 12/1/19.
//  Copyright © 2019 Ballygorey Apps. All rights reserved.
//

import SwiftUI
import StoreKit

struct TabBarViewController: View {
    @State var selection: Int = 0
    @EnvironmentObject var timerSession: TimerSession
    @ObservedObject var productsStore : ProductsStore
    @State var showOnboardingScreen = defaults.bool(forKey: showOnboardingKey)
    @State var presentSettingsModal: Bool = false
    @State var isShowingMailView = false
    @State var showMailAlert = false
        
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
    
    var reviewAlert: Alert {
        Alert(
            title: Text("Have you been enjoying DDK"),
            message: Text("Have you felt DDK Useful."),
            primaryButton: .default(Text("Yes"), action: {
                self.timerSession.setLogCount(num: 0)
                SKStoreReviewController.requestReview()
            }),
            secondaryButton: .default(Text("No"), action: {
                self.timerSession.setLogCount(num: 0)
                self.timerSession.activeAlert = .email
            })
        )
    }
    
    var sendEmailAlert: Alert {
        Alert(
            title: Text("Send a feedback Report"),
            message: Text("Send an email?"),
            primaryButton: .default(Text("Yes"), action: {
                self.selection = 2
                self.presentSettingsModal = true
                self.isShowingMailView = true
                    
            }),
            secondaryButton: .default(Text("No"))
        )
    }
    
    
//    var SendEmailAlert: Alert {
//        Alert(title: Text("Send a feedback Report"), message: Text("Send an email?"),
//              primaryButton: .default(Text("No"), action: {
//            print("no")
//              self.timerSession.setLogCount(num: 0)
//              }),
//              secondaryButton: .default(Text("Yes"), action: {
//                self.selection = 2
//                self.presentSettingsModal = true
//                self.isShowingMailView = true
//                self.showMailAlert = true
//                self.timerSession.setLogCount(num: 0)
//              }))
//    }
    
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
                        
                        TapHistoryList(presentSettingsModal: $presentSettingsModal, isShowingMailView: $isShowingMailView).environmentObject(timerSession)
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
                    
                }.alert(isPresented: $timerSession.showCentralAlert) {
                    switch timerSession.activeAlert {
                        case .buying:
                            return helpAlert
                        case .review:
                            return reviewAlert
                        case .email:
                            return sendEmailAlert
                        case .none:
                            return Alert(title: Text("Uhhh idk why this popped up. Ignore and report to developer."))
                    }
                }
            }
        }
    }
    
    let ExposePromptColor = Color(#colorLiteral(red: 1, green: 0.08433114744, blue: 0, alpha: 0))
    
    func showMailPrompt() -> some View {
        ZStack {
            ExposePromptColor
        }
        .alert(isPresented: $showMailAlert) {
            sendEmailAlert
        }
    }
    func supportDevPrompt() -> some View {
        ZStack {
            ExposePromptColor
        }
        .alert(isPresented: $timerSession.showSupportAd) {
            helpAlert
        }
    }
    func reviewTheAppPrompt() -> some View {
        ZStack {
            ExposePromptColor
        }
        .alert(isPresented: $timerSession.showReviewAd) {
            reviewAlert
        }
    }
    
}

//.accentColor(Color(#colorLiteral(red: 0.3339039057, green: 0.7535954078, blue: 0.711665441, alpha: 1)))
