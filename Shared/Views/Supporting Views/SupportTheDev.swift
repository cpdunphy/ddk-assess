//
//  SuppportTheDev.swift
//  Diadochokinetic Assess
//
//  Created by Collin Dunphy on 9/29/20.
//

import SwiftUI
import StoreKit

struct SupportTheDev: View {
    
    @EnvironmentObject var store : Store
        
    var product : Product
    
    var body: some View {
        ZStack(alignment: .bottom) {

            ScrollView {
                DonateDescription().padding(20)
            }
            
            HStack(spacing: 20) {
                if !store.productOptions.isEmpty {
                    Button {
                        Task { await buy() }
                    } label: {
                        ProductButton(product)
                    }.buttonStyle(PlainButtonStyle())
                } else {
                    Text("No support options currently available.")
                        .padding()
                        .modifier(NeonButtonStyle())
                }
            }.padding(.bottom, 30)
        }
        .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all)) //TODO: Add Mac Compatability
        .navigationTitle("Donation")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func buy() async {
        do {
            if try await store.purchase(product) != nil {
                withAnimation {
                    //TODO: Do stuff here
                }
            }
        } catch StoreError.failedVerification {
            //TODO: Pop Error Here
        } catch {
            print("Failed purchase for \(product.id): \(error)")
        }
    }
}

struct ProductButton : View {
    
    @EnvironmentObject var store : Store
    @Environment(\.colorScheme) var colorScheme
    
    var product: Product
    
    init(_ product: Product) {
        self.product = product
    }
    
    var body: some View {
        HStack {
            Text(store.emoji(for: product.id))
                .font(.largeTitle)
//                .padding(.bottom, 3)
                .padding(.trailing, 4)
            
            VStack(alignment: .leading) {
                Text(product.displayName)
                    .foregroundColor(.accentColor)
                    .font(.headline)
                    .fontWeight(.medium)

                Text(product.displayPrice)
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 30)
        .modifier(NeonButtonStyle())
    }
}

struct NeonButtonStyle: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color(.systemGroupedBackground)) //TODO: Add Mac Compatability
                    .shadow(radius: 8, x: 4, y: 4)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(colorScheme == .light ? Color.clear : Color.accentColor, lineWidth: 2)
            )
    }
}

struct DonateDescription : View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Why Donate? 🎁")
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.bottom, 4)
            
            Text(termsIAPText)
                .font(.title3)
                .fontWeight(.regular)
        }.layoutPriority(1.0)
    }
    
    var termsIAPText : String = "I built this app after talking with my aunt, who is a speech pathologist. This is my first app I have published, and plan to go to college next year to study engineering or computer science (and hopefully publish more apps). If you like this app and find it useful, please consider buying me a snack.\n\nThank you for your consideration,\nCollin"

}
