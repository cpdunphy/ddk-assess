//
//  OnboardingOptions.swift
//  Diadochokinetic Assess
//
//  Created by Collin Dunphy on 3/11/22.
//

import SwiftUI
import StoreKit

struct OnboardingOptions: View {
    
    @EnvironmentObject var store : Store
    
    @Environment(\.dismiss) var dismiss

    @State private var selectedOption: Product?
    
    @Binding var errorTitle : String
    @Binding var isShowingError : Bool
    
    var body: some View {
        NavigationView {
            ScrollView {
            VStack {
                
                Spacer()
                
                // Options
                ForEach(store.subscriptions) { product in
                    Button {
                        withAnimation(.easeOut(duration: 0.15)) {
                            selectedOption = product
                        }
                    } label: {
                        ProductOption(option: product, selection: $selectedOption)
                            .padding()
                            #if !os(macOS)
                            .background(Color(.systemBackground))
                            #endif
                            .cornerRadius(10.0)
                            .shadow(color: .black.opacity(0.25), radius: 7, x: -2, y: 4)
                            .padding(.bottom)
                    }
                    .buttonStyle(.plain)
                }
            
                Spacer()
                
                // Checkout
                Button(
                    "Continue to Checkout \(Image(systemName: "chevron.forward"))",
                    action: {
                        guard let product : Product = selectedOption else { return }
                        
                        Task {
                            await buy(product: product)
                        }
                    }
                )
                    .buttonBorderShape(.capsule)
                    .buttonStyle(.borderedProminent)
                
                // Reedeem Promo Code Button
                Button(
                    "Redeem Code",
                    action: {
                        SKPaymentQueue.default().presentCodeRedemptionSheet()
                    }
                )
                .padding(.vertical, 6)
                
                // Terms of Serivce & Privacy Policy
                Text("[Terms of Service](https://ballygorey.com) and [Privacy Policy](https://ballygorey.com)")
                    .font(.subheadline)
                
            }
                
            .scenePadding()
            #if !os(macOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .interactiveDismissDisabled()
            .onAppear(perform: setDefaultProductSelection)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel, action: { dismiss() })
                }
            }
            }
        }
    }
    
    func setDefaultProductSelection() {
        //TODO: Set the default product to the one that makes me the most money 🤑
    }
    
    
    func buy(product: Product) async {
        do {
            if try await store.purchase(product) != nil {
                //withAnimation {
                    //isPurchased = true
                //}
            }
        } catch StoreError.failedVerification {
            errorTitle = "Your purchase could not be verified by the App Store."
            isShowingError = true
        } catch {
            print("Failed purchase for \(product.id): \(error)")
        }
    }
}

//struct OnboardingOptions_Previews: PreviewProvider {
//    static var previews: some View {
//        OnboardingOptions()
//    }
//}
