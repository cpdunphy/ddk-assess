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
        Form {
            
            // User Preferences
            Section("User Preferences") {
                Toggle("Show Decimal on Timer", isOn: $showDecimalOnTimer)
            }
            
            // Reset Preferences
            Section {
                Button {
                    showResetConfirmationAlert = true
                } label: {
                    Label("Reset Preferences", systemImage: "exclamationmark.arrow.circlepath")
                }.foregroundColor(.red)
            }
            
            // Support The Dev
            #if os(iOS)
            Section("Support") {
                if !store.supportProductOptions.isEmpty {
                    ForEach(store.supportProductOptions.sorted { $0.productIdentifier < $1.productIdentifier }, id: \.self) { product in
                        NavigationLink(
                            destination: SupportTheDev(product: product)
                        ) {
                            Text("Buy the developer a \(product.localizedTitle) \(Store.getEmoji(id: product.productIdentifier))")
                        }
                    }
                } else {
                    Text("No Support Options Currently Available")
                        .font(.footnote)
                }
            }
            #endif
                                 
            // App Information + More
            Section("Information") {
                NavigationLink(
                    destination: AboutDDK()
                ) {
                    Label("About", systemImage: "d.circle.fill")
                        .symbolRenderingMode(.multicolor)
                        .imageScale(.large)
                }
                
                #if os(iOS)
                Button {
                    showingMailView.toggle()
                } label: {
                    Label("Support/Feedback", systemImage: "paperplane")
                        .symbolVariant(.fill)
                }.disabled(!MFMailComposeViewController.canSendMail())
                #endif
                
                Link(
                    destination: URL(string: "itms-apps://itunes.apple.com/app/id\(1489873060)?action=write-review&mt=8")!
                ) {
                    Label("Do you love DDK?", systemImage: "suit.heart")
                        .symbolRenderingMode(.multicolor)
                        .symbolVariant(.fill)
                }
            }
            
        }
    }
    
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
        model.resetTimed()
        model.resetCount()
    }
    
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreen()
    }
}
