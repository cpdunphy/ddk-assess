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
                //                .frame(width: geo.size.width)
                
                if let product = longTermSubscription {
                    VStack(spacing: 16) {
                        Text("Start with a 1 month free trial.")
                            .font(.headline)
                            .foregroundColor(.accentColor)
                        
                        VStack {
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
                            
                            Text("(12 months at $0.25/mo. Save \(Int((savings * 100).rounded()))%)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Text("\(longTermSubscription?.subscription?.subscriptionPeriod.value ?? 0)")
                        }
                        
                        
                        Text("[Terms of Service](https://ballygorey.com) and [Privacy Policy](https://ballygorey.com)")
                            .font(.subheadline)
                        
                        Button("Redeem Code", action: {
                            SKPaymentQueue.default().presentCodeRedemptionSheet()
                        })
                            .padding(.vertical)
                        
                        Button("Restore Purchases", action: {
                            print(store.purchasedIdentifiers)
                        })
                        
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
        .alert(isPresented: $isShowingError, content: {
            Alert(title: Text(errorTitle), message: nil, dismissButton: .default(Text("Okay")))
        })
    }
    
    var savings : Double {
        calculateSavings(
            of: longTermSubscription?.price ?? 0,
            over: longTermSubscription?.subscription?.subscriptionPeriod.value ?? 0,
            comparedTo: shortTermSubscription?.price ?? 0,
            over: shortTermSubscription?.subscription?.subscriptionPeriod.unit ?? .month
        )
    }
    
    //    func calculateSavings(of longTermPrice : Int, over period : Product.SubscriptionPeriod, ) {
    func calculateSavings(of longTermPrice : Decimal, over longTermPeriod : Int, comparedTo shortTermPrice : Decimal, over shortTermPeriod : Product.SubscriptionPeriod.Unit) -> Double {
        // 1- ((2.99)/(0.99*12))
        
        //        let longTermPrice = longTermSubscription?.price ?? 0
        //        let shortTermPrice = shortTermSubscription?.price ?? 0
        
        // Long term period in short term units
        //        let longTermPeriod = longTermSubscription?.subscription?.subscriptionPeriod.value ?? 0
        //        let shortTermUnit = shortTermSubscription?.subscription?.subscriptionPeriod.unit
        
        var longTermConversionFactor = 1
        
        switch shortTermPeriod {
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
