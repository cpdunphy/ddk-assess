//
//  ProductsStore.swift
//  Diadochokinetic Assess
//
//  Created by Collin on 12/9/19.
//  Copyright © 2019 Ballygorey Apps. All rights reserved.
//
//  https://apphud.com

import Foundation
import SwiftUI
import Combine
import StoreKit

class ProductsStore : ObservableObject {

    let productIdentifierArray : Set<String> = [
        "com.Ballygorey.Diadochokinetic_Assess.SupportTheDev",
        "com.Ballygorey.Diadochokinetic_Assess.SupportTheDev2",
        "com.Ballygorey.Diadochokinetic_Assess.SupportTheDev3"
    ]
    
    static let shared = ProductsStore()
    
    @Published var products: [SKProduct] = []
    @Published var anyString = "123" // little trick to force reload ContentView from PurchaseView by just changing any Published value
    
    func handleUpdateStore(){
        anyString = UUID().uuidString
    }
    
    func initializeProducts(){
        IAPManager.shared.startWith(arrayOfIds: productIdentifierArray, sharedSecret: shared_secret) { products in
            self.products = products
        }
    }
}
