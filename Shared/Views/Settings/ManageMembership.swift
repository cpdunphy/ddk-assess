//
//  Membership.swift
//  Diadochokinetic Assess
//
//  Created by Collin Dunphy on 10/17/21.
//

import SwiftUI

struct ManageMembership: View {
    
    @State private var manageSubscription : Bool = false
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("Manage Membership")
                    .font(.title3)
                    .fontWeight(.bold)
                Divider()
            }
            
            VStack {
                Text("If you're considering ending your use, we would love to hear from you why. You can let us know by sending us a message. We personally read all feedback!")
                
                // Message the Team Mail Prompt
                Button("Message our team") {
                    
                }
                .buttonStyle(.borderedProminent)
                .font(.title2)
                
                // Manage Subscription Link
                Button("Manage Subscription") {
                    manageSubscription = true
                }
                .buttonStyle(.borderedProminent)
                .font(.title2)
                
                Text("This will take you to the Settings app to manage your subscription.")
                    .foregroundColor(.secondary)
                    .font(.subheadline)
            }
            
            Spacer()
        }
        .scenePadding()
        .navigationTitle("Membership")
        .navigationBarTitleDisplayMode(.inline)
        .manageSubscriptionsSheet(isPresented: $manageSubscription)
        .toolbar {
            restoreButton
        }
    }
    
    var restoreButton : some View {
        Button {
            
        } label: {
            Label("Restore", systemImage: "arrow.counterclockwise")
                .labelStyle(.titleOnly)
        }
    }
}

struct Membership_Previews: PreviewProvider {
    static var previews: some View {
        ManageMembership()
    }
}
