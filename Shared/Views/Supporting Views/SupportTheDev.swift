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
    
    var product : [SKProduct]? = nil
    
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            DonateDescription()
            LazyHStack(spacing: 20) {
                if !store.supportProductOptions.isEmpty {
                    ForEach(product ?? store.supportProductOptions.sorted { $0.productIdentifier < $1.productIdentifier }, id: \.productIdentifier) { item in
                        Button(action: {
                            store.purchaseProduct(item)
                        }) {
                            ProductButton(item)
                        }.buttonStyle(PlainButtonStyle())
                    }
                } else {
                    Text("No support options currently available.")
                        .padding()
                        .modifier(NeonButtonStyle())
                }
            }
        }
        .padding(20)
        .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all)) //TODO: Add Mac Compatability
        .navigationTitle("Donation")
    }
}

struct SuppportTheDev_Previews: PreviewProvider {
    static var previews: some View {
        SupportTheDev()
    }
}


struct ProductButton : View {
    
    @EnvironmentObject var store : Store
    @Environment(\.colorScheme) var colorScheme
    
    var skproduct: SKProduct
    
    init(_ skproduct: SKProduct) {
        self.skproduct = skproduct
    }
    
    var body: some View {
        VStack {
            Text(store.getEmoji(id: skproduct.productIdentifier))
                .font(.largeTitle)
                .padding(.bottom, 3)
            
            Text(skproduct.localizedTitle)
                .foregroundColor(.accentColor)
                .font(.headline)
                .fontWeight(.medium)

                Text("$\(product.price)")
                    .font(.footnote)
                    .foregroundColor(.secondary)
        }
        .frame(idealWidth: 150, maxWidth: 200, idealHeight: 100, maxHeight: 125)
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
                    .shadow(radius: 10)
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
    
    var termsIAPText : String = "I built this app after talking with my aunt, who is a speech pathologist. This is my first app I have published, and plan to go to college next year to study engineering or computer science (and hopefully publish more apps). If you like this app and find it useful, please consider buying me a snack.\n\nThank you for your consideration,\n - Collin"

}
