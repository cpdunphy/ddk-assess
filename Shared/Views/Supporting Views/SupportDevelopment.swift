//
//  SupportDevelopment.swift
//  Diadochokinetic Assess (iOS)
//
//  Created by Collin Dunphy on 7/25/22.
//

import StoreKit
import SwiftUI

struct SupportDevelopment: View {
    
    @EnvironmentObject var store : Store
    var body: some View {
        
        ScrollView {
            VStack {
                Text("Why Donate? 🎁")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.bottom, 4)
                
                Text("**A hangry developer is an unproductive developer.** If you like the app, throw me a bone (or a smoothie). I'm a College Student studying Computer Science and could use as many \"late night snacks\" as I can!\nThank you for your support!")
                    .multilineTextAlignment(.center)
                
                Divider()
                    .padding(.top)
                
                ForEach(
                    store.supportProductOptions.sorted {
                        $0.productIdentifier < $1.productIdentifier
                    },
                    id: \.self
                ) { product in
                    VStack(spacing: 4) {
                        HStack {
                        
                            Text(Store.getEmoji(id: product.productIdentifier))
                                .font(.largeTitle)
                                .padding(.trailing, 4)
                            
                                Text(product.localizedTitle)
                                    .foregroundColor(.accentColor)
                                    .font(.headline)
                                    .fontWeight(.medium)
                            
                            VStack {
                                Divider().padding(.horizontal)
                            }
                            
                            Button("$\(product.price)") {
                                Task { await buy(product) }
                            }
                            .buttonStyle(.borderedProminent)
                            .buttonBorderShape(.capsule)
                        }
//                        Divider()
                        
                    }
                }
            }
            .scenePadding()
            
            .navigationTitle("Donate")
            .navigationBarTitleDisplayMode(.inline)
        }

    }
    
    func buy(_ product: SKProduct) async {
        do {
            if try await store.purchaseProduct(product) != nil {
                withAnimation {
                    //TODO: Do stuff here
                }
            }
        } catch StoreError.failedVerification {
            //TODO: Pop Error Here
        } catch {
            print("Failed purchase for \(product.productIdentifier): \(error)")
        }
    }
}

struct SupportDevelopment_Previews: PreviewProvider {
    static var previews: some View {
        SupportDevelopment()
    }
}
