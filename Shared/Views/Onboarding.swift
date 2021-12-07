//
//  Onboarding.swift
//  Diadochokinetic Assess (iOS)
//
//  Created by Collin Dunphy on 12/2/21.
//

import SwiftUI
import StoreKit

struct Onboarding: View {
    @EnvironmentObject var store: Store
    
    @State var errorTitle = ""
    @State var isShowingError: Bool = false
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                Text("DDK")
                    .font(.system(.largeTitle, design: .rounded))
                    .bold()
                    .foregroundColor(.white)
                
                TabView {
                    OnboardingPage(
                        title: "Unlock All Access",
                        subtitle: "Whether its for personal or professional use, DDK can provide support in numerous ways.",
                        systemSymbol: "hand.tap",
                        width: geo.size.width
                    )
                    
                    Text("Beep")
                        .scenePadding()
                    
                    Text("Boop")
                        .scenePadding()
                }
                .tabViewStyle(.page)
                
                if let product = longTermSubscription {
                    VStack(spacing: 16) {
                        
                        // Promo offer details
                        Text("Start with a 1 month free trial.")
                            .font(.headline)
                            .foregroundColor(.accentColor)
                        
                        VStack {
                            
                            // Subscribe Button
                            Button {
                                Task {
                                    await buy(product: product)
                                }
                            } label: {
                                Text("Subscribe for \(product.displayPrice) / \(product.subscription?.subscriptionPeriod.unit.debugDescription.lowercased() ?? "")")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .padding(4)
                                    .padding(.horizontal)
                            }
                            .buttonStyle(.borderedProminent)
                            
                            // Savings Caption
                            Group {
                                Text("(")
                                + Text("12 months at $0.25/mo.")
                                + Text(" Save ")
                                + Text(((savings * 100).rounded()) / 100, format: .percent)
                                + Text(")")
                            }
                            .font(.caption)
                            .foregroundColor(.secondary)
                        }
                        
                        // Terms of Serivce & Privacy Policy
                        Text("[Terms of Service](https://ballygorey.com) and [Privacy Policy](https://ballygorey.com)")
                            .font(.subheadline)
                        
                        // Reedeem Promo Code Button
                        Button("Redeem Code", action: {
                            SKPaymentQueue.default().presentCodeRedemptionSheet()
                        })
                            .padding(.vertical)
                        
                        
                        // Restore Purchases Button
                        Button(
                            "Restore Purchases",
                            action: {
                                Task {
                                    //This call displays a system prompt that asks users to authenticate with their App Store credentials.
                                    //Call this function only in response to an explicit user action, such as tapping a button.
                                    
                                    try? await AppStore.sync()
                                }
                            }
                        )
                        
                    }
                    .scenePadding()
                    .frame(maxWidth: .infinity)
                    .background(.thinMaterial)
                    
                }
            }
            
        }
        .background(
            Image("Background-V1")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
        )
        
        .alert(
            isPresented: $isShowingError,
            content: {
                Alert(title: Text(errorTitle), message: nil, dismissButton: .default(Text("Okay")))
            }
        )
    }
    
    var savings : Double {
        calculateSavings(
            of: longTermSubscription,
            comparedTo: shortTermSubscription
        )
    }
    
    func calculateSavings(of longTermSubscription : Product?, comparedTo shortTermPrice : Product?) -> Double {
        
        let longTermPrice = longTermSubscription?.price ?? 0
        let shortTermPrice = shortTermSubscription?.price ?? 0
        
        // Long term period in short term units
        let longTermPeriod = longTermSubscription?.subscription?.subscriptionPeriod.value ?? 0
        let shortTermUnit = shortTermSubscription?.subscription?.subscriptionPeriod.unit
        
        var longTermConversionFactor = 1
        
        switch shortTermUnit {
        case .year:
            longTermConversionFactor = 1
        case .month:
            longTermConversionFactor = 12
        default:
            print("This unit isn't supported")
        }
        
        let savings : Decimal = Decimal(1) - ((longTermPrice) / (shortTermPrice * Decimal(longTermPeriod * longTermConversionFactor)))
        
        return NSDecimalNumber(decimal: savings).doubleValue
    }
    
    var longTermSubscription : Product? {
        store.subscriptions.first(
            where: {
                $0.id == "com.ballygorey.ddk.yearly"
            }
        )
    }
    
    var shortTermSubscription : Product? {
        store.subscriptions.min(by: { $0.subscription?.subscriptionPeriod.value ?? 0 < $1.subscription?.subscriptionPeriod.value ?? 0 })
    }
    
    func buy(product: Product) async {
        do {
            if try await store.purchase(product) != nil {
                //                withAnimation {
                //                    isPurchased = true
                //                }
            }
        } catch StoreError.failedVerification {
            errorTitle = "Your purchase could not be verified by the App Store."
            isShowingError = true
        } catch {
            print("Failed purchase for \(product.id): \(error)")
        }
    }
}

struct Onboarding_Previews: PreviewProvider {
    static var previews: some View {
        Onboarding()
    }
}

struct OnboardingPage : View {
    
    var title: String
    var subtitle: String
    var systemSymbol : String
    var width : CGFloat
    
    var body : some View {
        VStack {
            Text(title)
                .font(.system(.title3, design: .rounded))
                .fontWeight(.semibold)
            
            Text(subtitle)
            
            Spacer()
            
            Image(systemName: systemSymbol)
                .font(.system(size: 96))
                .symbolVariant(.fill)
                .padding()
                .background(.black.opacity(0.18), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
            
            Spacer()
        }
        .foregroundColor(.white)
        .scenePadding()
        .frame(width: width)
    }
}
