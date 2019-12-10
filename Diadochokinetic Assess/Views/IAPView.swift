//
//  IAPView.swift
//  Diadochokinetic Assess
//
//  Created by Collin on 12/10/19.
//  Copyright © 2019 Ballygorey Apps. All rights reserved.
//
import Combine
import SwiftUI
import StoreKit
import Foundation

struct IAPView: View {
    var product : SKProduct!
    
    var body: some View {
        ZStack {
            Color("background")
            VStack {
                Spacer()
                VStack(spacing: 10) {
                    Text(donationEmoji(str: product.localizedTitle))
                        .font(.system(size: 100))
                    Text(product.localizedTitle)
                        .font(.custom("Nunito-Bold", size: 25))
                    Text(product.localizedDescription)
                        .font(.custom("Nunito-SemiBold", size: regularTextSize))
                }
                Spacer()
                Text(termsIAPText)
                    .font(.custom("Nunito-Light", size: 13))
                    .foregroundColor(Color(UIColor.secondaryLabel))
 
                PurchaseButton(
                    block: {self.purchaseProduct(skproduct: self.product)},
                    product: product
                )
                    .padding([.bottom, .top])
            }.frame(width: Screen.width * 0.85)
                .navigationBarTitle(Text("Donation"), displayMode: .inline)
        }
        
    }
    func purchaseProduct(skproduct: SKProduct) {
        print("did tap purchase product: \(skproduct.productIdentifier)")
//        isDisabled = true
        IAPManager.shared.purchaseProduct(product: skproduct, success: {
//            self.isDisabled = false
            ProductsStore.shared.handleUpdateStore()
//            self.dismiss()
        }) { (error) in
//            self.isDisabled = false
            ProductsStore.shared.handleUpdateStore()
        }
    }
}

/*struct IAPView_Previews: PreviewProvider {
    static var previews: some View {
        IAPView()
    }
}*/

struct PurchaseButton : View {
    
    var block : SuccessBlock!
    var product : SKProduct!
    
    var body: some View {
        
        Button(action: {
            print("pressed")
            self.block()
        }) {
            self.button()
        }.frame(width: Screen.width * 0.85, height: Screen.height * 0.1)
    }
    
    func button() -> some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color("AccentColor"))
                .cornerRadius(10)
                .shadow(radius: 2)
                    
            Text("$\(product.price)").font(.custom("Nunito-SemiBold", size: 33)).lineLimit(1).foregroundColor(Color(#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)))
        }
    }
}

struct IAPLabel : View {
    var product : SKProduct!
    
    var body : some View {
        Text("Buy the developer a \(product.localizedTitle) \(donationEmoji(str: product.localizedTitle))")
            .font(.custom("Nunito-Regular", size: regularTextSize))
//            .foregroundColor(Color("AccentColor"))
            .foregroundColor(.blue)
    }
}



func donationEmoji(str: String) -> String {
    switch str {
    case "Donut":
        return "🍩"
    case "Smoothie":
        return "🍹"
    case "Meal":
        return "🍔"
    default:
        break
    }
    return "❤️"
}
