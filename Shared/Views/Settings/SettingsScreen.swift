//
//  Settings.swift
//  Diadochokinetic Assess
//
//  Created by Collin Dunphy on 9/29/20.
//

import SwiftUI

import StoreKit

#if os(iOS)
import MessageUI
#endif

import Shiny

struct SettingsScreen: View {
    
    @EnvironmentObject var model : DDKModel
    @EnvironmentObject var store : Store
        
    @AppStorage("show_decimal_timer") var showDecimalOnTimer : Bool = true
    
    @State private var showResetConfirmationAlert : Bool = false
    
    #if os(iOS)
    @State private var mailResult:          Result<MFMailComposeResult, Error>? = nil
    @State private var showingMailView :    Bool = false
    #endif
       
    // MARK: - Form
    var form: some View {
        List {
            
            Section("Getting Started") {
                Button {
                    
                } label: {
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "atom")
                                .font(.largeTitle)

                            Text("What's new in\nTritium 2")
                                .font(.system(.title2, design: .rounded))
                                .fontWeight(.bold)
                                .fixedSize(horizontal: false, vertical: true)

                        }
                        .shiny(.init(colors: [.cyan, .teal]))
                        .padding(.bottom, 8)
                        
                        Text("50+ new features. A total redesign. See what's new in the biggest update to Tritium yet.")
                            .fixedSize(horizontal: false, vertical: true)
                            .foregroundColor(.primary)
                        
                    }.padding(.vertical, 8)
                }
            }
            
            // Manage Subscription
            Section("Membership") {
                NavigationLink(destination: ManageMembership()) {
                    SettingsScreenButton(
                        title: "Manage your Membership",
                        symbolSystemName: "staroflife",
                        symbolColor: .accentColor
                    ).symbolVariant(.fill)
                }
            }
            
            
            /*
            // Support The Dev
            #if os(iOS)
            Section("Support") {
                if !store.productOptions.isEmpty {
                    ForEach(store.productOptions) { product in
                        NavigationLink(
                            destination: SupportTheDev(product: product)
                        ) {
                            Text("Buy the developer a \(product.displayName) \(store .emoji(for: product.id))")
                        }
                    }
                } else {
                    Text("No Support Options Currently Available")
                        .font(.footnote)
                }
            }
            #endif
             */
             
            // App Information + More
            Section("Information") {
                
                NavigationLink(
                    destination: AboutDDK()
                ) {
                    SettingsScreenButton(
                        title: "About",
                        symbolSystemName: "info.circle",
                        symbolColor: .accentColor
                    )
                }
                
                #if os(iOS)
                Button {
                    showingMailView.toggle()
                } label: {
                    SettingsScreenButton(
                        title: "Support / Feedback",
                        symbolSystemName: "questionmark.diamond.fill"
                    ).symbolRenderingMode(.multicolor)
                }.disabled(!MFMailComposeViewController.canSendMail())
                #endif
                
                Link(
                    destination: URL(string: "itms-apps://itunes.apple.com/app/id\(1489873060)?action=write-review&mt=8")!
                ) {
                    SettingsScreenButton(
                        title: "Do you love DDK?",
                        symbolSystemName: "suit.heart.fill",
                        symbolColor: .pink
                    )
                }
                
            }
            
            // Reset Preferences
            Section {
                Button {
                    showResetConfirmationAlert = true
                } label: {
                    Label("Reset Preferences", systemImage: "exclamationmark.arrow.circlepath")
                }.foregroundColor(.red)
            }
            
        }
        
    }
    @State private var testing : Bool = false

    // MARK: - Body
    var body: some View {
        form
            .navigationTitle("Settings")
        
        // Reset Settings Confirmation
            .alert(
                "Reset Preferences",
                isPresented: $showResetConfirmationAlert,
                actions: {
                    Button("Cancel", role: .cancel) { }
                    
                    Button("Reset", role: .destructive, action: resetPreferences)
                },
                message: {
                    Text("Are you sure you want to reset all preferences?")
                }
            )
        
        // Mail Popover Sheet
            .sheet(isPresented: $showingMailView) {
                MailView(result: $mailResult)
            }
        
    }
    
    func resetPreferences() {
        model.currentlySelectedTimerLength = 10
        showDecimalOnTimer = true
        //TODO: Reset all models and their subsequent preferences.
    }
    
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreen()
    }
}
