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
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            VStack(alignment: .leading) {
                Text("Why Donate? 🎁")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.bottom, 4)
                
                Text(termsIAPText)
                    .font(.title3)
                    .fontWeight(.regular)
//                    .multilineTextAlignment(.center)
            }
//            Spacer()
            LazyHStack(spacing: 20) {
                
                ForEach(store.supportProductOptions, id: \.productIdentifier) { item in
                    Button(action: {
                        
                    }) {
                        productButton(item)
                    }.buttonStyle(PlainButtonStyle())
                }
            }
        }
        .padding(20)
        .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
        .navigationTitle("Donation")
    }
    
    func productButton(_ skproduct: SKProduct) -> some View {
        VStack {
            Text(store.getEmoji(id: skproduct.productIdentifier))
                .font(.largeTitle)
                .padding(.bottom, 3)
            
            Text("Testing")
                .foregroundColor(.accentColor)
                .font(.headline)
                .fontWeight(.medium)

            Text("\(skproduct.price)")
                .font(.footnote)
                .foregroundColor(.secondary)
        }
        .frame(idealWidth: 150, maxWidth: 200, idealHeight: 100, maxHeight: 125)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color(.systemGroupedBackground))
                .shadow(radius: 10)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(colorScheme == .light ? Color.clear : Color.accentColor, lineWidth: 2)
        )
    }
    
    var termsIAPText : String = "I built this app after talking with my aunt, who is a speech pathologist. This is my first app I have published, and plan to go to college next year to study engineering or computer science (and hopefully publish more apps). If you like this app and find it useful, please consider buying me a snack.\n\nThank you for your consideration,\n - The developer"
    
}

struct SuppportTheDev_Previews: PreviewProvider {
    static var previews: some View {
        SupportTheDev()
    }
}
