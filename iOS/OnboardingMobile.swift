//
//  OnboardingMobile.swift
//  Diadochokinetic Assess (iOS)
//
//  Created by Collin Dunphy on 12/2/21.
//

import SwiftUI
import StoreKit

struct OnboardingMobile: View {
    @EnvironmentObject var store: Store
    
    @State private var errorTitle : String = ""
    @State var isShowingError: Bool = false
    @State private var isOptionsModalOpen : Bool = false
    
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 12) {
                Text("DDK")
                    .font(.system(.largeTitle, design: .rounded))
                    .fontWeight(.bold)
                
                TabView {
                    OnboardingPage(
                        title: "Unlock All Access",
                        subtitle: "Whether its for personal or professional use, DDK can provide support in numerous ways.",
                        imageName: "iPhone 13 Pro",
                        width: geo.size.width
                    )
                        .padding(.bottom, 35)

                    OnboardingPage(
                        title: "Unlock All Access",
                        subtitle: "Whether its for personal or professional use, DDK can provide support in numerous ways.",
                        imageName: "iPhone 13 Pro",
                        width: geo.size.width
                    )
                        .padding(.bottom, 35)

                    OnboardingPage(
                        title: "Unlock All Access",
                        subtitle: "Whether its for personal or professional use, DDK can provide support in numerous ways.",
                        imageName: "iPhone 13 Pro",
                        width: geo.size.width
                    )
                        .padding(.bottom, 35)
                }
                .tabViewStyle(.page)
                
//                Spacer(minLength: 0)
                
                VStack {
                    // Starting Price
                    Text("Starting at $0.99/month")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.bottom, 4)
                    
                    // Open Product Selection Modal
                    Button {
                        isOptionsModalOpen = true
                    } label: {
                        Text("Choose Your Plan")
                            .padding(.vertical, 4)
                            .frame(maxWidth: .infinity)
                    }
                        .buttonStyle(.borderedProminent)
                        .buttonBorderShape(.capsule)
                        .padding(.bottom)
                    
                    // Restore Purchases Button
                        Button(
                        "Subscribed already?",
                        action: {
                            Task {
                                //This call displays a system prompt that asks users to authenticate with their App Store credentials.
                                //Call this function only in response to an explicit user action, such as tapping a button.
                                
                                try? await AppStore.sync()
                            }
                        }
                    )
                }
                .scenePadding(.horizontal)
                .scenePadding(.bottom)
            }
        }
        
//        .alert(
//            item: $errorTitle
//            content: {
//                Alert(title: Text(errorTitle), message: nil, dismissButton: .default(Text("Okay")))
//            }
//        )
        
        .alert(errorTitle, isPresented: $isShowingError, actions: {
            //TODO: Actions??
        })
        .sheet(isPresented: $isOptionsModalOpen) {
            OnboardingOptions(errorTitle: $errorTitle, isShowingError: $isShowingError)
        }
        
        
    }
    /*
    var open : some View {
        if let product = longTermSubscription {
            return VStack(spacing: 16) {
                
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
                Button(
                    "Redeem Code",
                    action: {
                        SKPaymentQueue.default().presentCodeRedemptionSheet()
                    }
                )
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
    */
    
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
        return store.subscriptions.sorted(by: { $0.price > $1.price }).first
    }
    
    var shortTermSubscription : Product? {
        store.subscriptions.min(by: { $0.subscription?.subscriptionPeriod.value ?? 0 < $1.subscription?.subscriptionPeriod.value ?? 0 })
    }
}

struct OnboardingMobile_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingMobile()
    }
}

struct OnboardingPage : View {
    
    var title: String
    var subtitle: String
    var imageName: String
    var width : CGFloat
    
    var body : some View {
        VStack {
            ZStack {

                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color(UIColor.secondarySystemBackground))
                    
                GeometryReader { geo in
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: geo.size.width * 0.9)
                        .position(x: geo.size.width / 2, y: geo.size.height / 2)
                        .offset(y: geo.size.height / 3)
                }
            }
            .clipped()
            
            Text(title)
                .font(.title)
                .bold()
                .foregroundColor(.primary)
                .padding(.bottom, 4)
            
            Text(subtitle)
                .foregroundColor(.secondary)
        }
        .foregroundColor(.white)
        .scenePadding()
        .frame(width: width)
    }
}

