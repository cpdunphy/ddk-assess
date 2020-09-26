//
//  SKStore.swift
//  Diadochokinetic Assess
//
//  Created by Collin Dunphy on 9/23/20.
//

import Foundation
import StoreKit

// MARK: - Store

class Store : ObservableObject {
    
    private let allProductIdentifiers = Set([Store.donateDonutIdentifier, donateSmoothieIdentifier, donateLunchIdentifier])
    
    init() {
        
    }
}

// MARK: - Store API

extension Store {
    static let donateDonutIdentifier = "com.Ballygorey.Diadochokinetic_Assess.SupportTheDev"
    static let donateLunchIdentifier = "com.Ballygorey.Diadochokinetic_Assess.SupportTheDev3"
    static let donateSmoothieIdentifier = "com.Ballygorey.Diadochokinetic_Assess.SupportTheDev2"

    
//    func product(for identifier: String) -> SKProduct? {
//        return fetchedProducts.first(where: { $0.productIdentifier == identifier })
//    }
//
//    func purchaseProduct(_ product: SKProduct) {
//        startObservingPaymentQueue()
//        buy(product) { [weak self] transaction in
//            guard let self = self,
//                  let transaction = transaction else {
//                return
//            }
//
//            // If the purchase was successful and it was for the premium recipes identifiers
//            // then publish the unlock change
//            if transaction.payment.productIdentifier == Store.unlockAllRecipesIdentifier,
//               transaction.transactionState == .purchased {
//                self.unlockedAllRecipes = true
//            }
//        }
//    }
}
