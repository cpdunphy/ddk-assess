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
//            ScrollView {
            Form {
                
//                Spacer()
                
                // Options
//                ForEach(store.subscriptions) { product in

//                }
                
                Section {
                    ForEach(store.subscriptions) { product in
                        Button {
                            withAnimation(.easeOut(duration: 0.15)) {
                                selectedOption = product
                            }
                        } label: {
                            ProductOption(option: product, selection: $selectedOption)
                                .padding(4)
                                .background(Color(.secondarySystemGroupedBackground).opacity(0.01))
                        }
                        .buttonStyle(.plain)
//                        .contentShape(Rectangle())
                    }
                }
//                Spacer()
                
                Section(footer: Text("[Terms of Service](https://ballygorey.com) and [Privacy Policy](https://ballygorey.com)")) {
                // Checkout
                    Button {
                        guard let product : Product = selectedOption else { return }
                        
                        Task {
                            await buy(product: product)
                        }
                    } label: {
                        HStack {
                            Text("Continue to Checkout")
                            Spacer()
                            Image(systemName: "chevron.forward")
                        }
                    }
//                    .buttonBorderShape(.capsule)
//                    .buttonStyle(.bordered)
//                    .buttonStyle(.borderedProminent)
                
                // Reedeem Promo Code Button
                Button(
                    "Redeem Code",
                    action: {
                        SKPaymentQueue.default().presentCodeRedemptionSheet()
                    }
                )
                .padding(.vertical, 6)
                
                // Terms of Serivce & Privacy Policy
//                Text()
//                    .font(.subheadline)
                }
                
            }
                
//            .scenePaddinxg()
            #if !os(macOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .interactiveDismissDisabled()
            .onAppear(perform: setDefaultProductSelection)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel, action: { dismiss() })
                }
//            }
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
