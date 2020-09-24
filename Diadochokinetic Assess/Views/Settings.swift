//
//  Settings.swift
//  Diadochokinetic Assess
//
//  Created by Collin on 12/1/19.
//  Copyright © 2019 Ballygorey Apps. All rights reserved.
//

import SwiftUI
import MessageUI

struct Settings: View {
    @State private var countdownCount = defaults.integer(forKey: countdownKey)
    @EnvironmentObject var timerSession : TimerSession
    var resetAlert: Alert {
        Alert(
            title: Text("Reset Preferences"),
            message: Text("Are you sure you want to reset all preferences?"),
            primaryButton: .cancel(Text("Cancel")),
            secondaryButton: .destructive(Text("Reset"), action: {
                self.resetOnClose = false
                self.presentSettingsModal = false
                defaults.set(3, forKey: countdownKey)
                defaults.set(5, forKey: secondsKey)
                defaults.set(false, forKey: heartRateKey)
                self.timerSession.ResetTimedMode()
                self.timerSession.stopUntimed()
                defaults.set(false, forKey: showOnboardingKey)
            })
        )
    }
    @State var resetOnClose = true
    @State var showResetConf: Bool = false
    @Binding var presentSettingsModal : Bool
    @State var result: Result<MFMailComposeResult, Error>? = nil
    @Binding var isShowingMailView : Bool
    var body: some View {
        
        NavigationView {
            Form {
                Section(header: Text("User Preferences").font(.custom("Nunito-Regular", size: regularTextSize-3))) {
                    Stepper(
                        onIncrement: {
                            if self.countdownCount < 60 {
                                self.countdownCount += 1
                                UserDefaults.standard.set(self.countdownCount, forKey: countdownKey)
                            }
                    },
                        onDecrement: {
                            if self.countdownCount > 0 {
                                self.countdownCount -= 1
                                UserDefaults.standard.set(self.countdownCount, forKey: countdownKey)
                            }
                    }) {
                        Text("Countdown Time: \(self.countdownCount) \(self.countdownCount == 1 ? "second" : "seconds")")
                        .font(.custom("Nunito-Regular", size: regularTextSize))
                    }
                }
                Section {
                    Button(action: {
                        self.showResetConf = true
                    }) {
                        Text("Reset Preferences")
                            .font(.custom("Nunito-Regular", size: regularTextSize))
                            .foregroundColor(.red)
                    }
                }
                Section {
                    
                    if ProductsStore.shared.products == [] {
                        Text("No Products Avaiable for Purchase")
                            .font(.custom("Nunito-Regular", size: regularTextSize))
                    } else {
                    
                        ForEach(ProductsStore.shared.products, id: \.self) { prod in
                            NavigationLink(destination: IAPView(product: prod)) { //Can add the 'isActive and link to a state var'
                                IAPRow(product: prod)
                            }
                        }
                    }
                }
                Section {
                    Button(action: {
                        self.isShowingMailView.toggle()
                    }) {
                        FeedbackText()
                    }.disabled(!MFMailComposeViewController.canSendMail())
                    /*NavigationLink(destination: MailView(result: self.$result)) {
                        Text("Send Feedback")
                    }.disabled(!MFMailComposeViewController.canSendMail())*/
                    ///TODO-V2: Can put output in ZStack to take up whole screen, would also get rid of dark mode bug in modal view
                }
                
            }
            .alert(isPresented: $showResetConf) {
                resetAlert
            }
            .sheet(isPresented: $isShowingMailView) {
                MailView(result: self.$result)
            }
            .navigationBarTitle("Settings")
            .navigationBarItems(trailing: CloseButton())
        }
        
    }
    func CloseButton() -> some View {
        Button(action: {
            self.presentSettingsModal = false
        }) {
            Text("Close")
                .foregroundColor(Color("AccentColor"))
        }
    }
    
    struct FeedbackText :View {
        var disabled = !MFMailComposeViewController.canSendMail()
        var body : some View {
            HStack {
                Image(systemName: "paperplane.fill")
                    .imageScale(.large)
                    .foregroundColor(disabled ?
                        .gray : .blue)
                
                VStack(alignment: .leading) {
                    Text("Submit Feedback")
                    Text("Help us improve the app.")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }.padding(.leading)
                
            }.padding()
        }
    }
    
}

//struct Settings_Previews: PreviewProvider {
//    static var previews: some View {
//        Settings()
//    }
//}
