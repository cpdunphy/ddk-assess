//
//  Store.swift
//  Diadochokinetic Assess
//
//  Created by Collin Dunphy on 10/08/21.
//

import Foundation
import StoreKit
import SwiftUI

typealias Transaction = StoreKit.Transaction

public enum StoreError : Error {
    case failedVerification
}

public enum AuthState: String {
    case undefined = "undefined"
    case unsubscribed = "unsubscribed"
    case subscribed = "subscribed"
}


// MARK: - Store

class Store : ObservableObject {
    
    @Published var productOptions : [Product] = []
    @Published private(set) var subscriptions: [Product]

    @Published private(set) var purchasedIdentifiers = Set<String>() { didSet { updateSubscriptionStatus() } }
    
    @AppStorage("isUserAuthenticated") private(set) var userAuthenticationStatus: AuthState = .undefined

    var updateListenerTask: Task<Void, Error>? = nil
        
    private let productIdToEmoji : [String: String]
    
    init() {
        if let path = Bundle.main.path(forResource: "Products", ofType: "plist"), let plist = FileManager.default.contents(atPath: path) {
            productIdToEmoji = (try? PropertyListSerialization.propertyList(from: plist, format: nil) as? [String: String]) ?? [:]
        } else {
            productIdToEmoji = [:]
        }

        // Init empty products then do a product request to fill them async
        productOptions = []
        subscriptions = []
        
        // Start a transaction listener as close to app launch as possible so you don't miss any transactions.
        updateListenerTask = listenForTransactions()
        
        Task {
            // Init the store by starting a product request.
            await requestProducts()
            await refreshPurchasedProducts()
            updateSubscriptionStatus()
        }
    }
    
    deinit {
        updateListenerTask?.cancel()
    }
    
    func updateSubscriptionStatus() {
        userAuthenticationStatus = purchasedIdentifiers.isEmpty ? .unsubscribed : .subscribed
    }

    @MainActor
    fileprivate func refreshPurchasedProducts() async {
        var purchasedSubscriptions: [Product] = []

        //Iterate through all of the user's purchased products.
        for await result in Transaction.currentEntitlements {
            //Don't operate on this transaction if it's not verified.
            if case .verified(let transaction) = result {
                //Check the `productType` of the transaction and get the corresponding product from the store.
                switch transaction.productType {
                case .autoRenewable:
                    if let subscription = subscriptions.first(where: { $0.id == transaction.productID }) {
                        purchasedSubscriptions.append(subscription)
                    }
                    await updatePurchasedIdentifiers(transaction)
                default:
                    //This type of product isn't displayed in this view.
                    break
                }
            }
        }
    }
    
    @MainActor
    func requestProducts() async {
        do {
            // Request products from the App Store using the identifiers defined in the Products.plist file.
            let storeProducts = try await Product.products(for: productIdToEmoji.keys)
            
            var newSupportOptions: [Product] = []
            var newSubscriptions: [Product] = []
            
            // Filter the products into different categories based on their type.
            for product in storeProducts {
                switch product.type {
                case .consumable:
                    newSupportOptions.append(product)
                case .autoRenewable:
                    newSubscriptions.append(product)
                default:
                    // Ignore this product.
                    print("Unknown product type")
                }
            }
            
            productOptions = sortByPrice(newSupportOptions)
            subscriptions = sortByPrice(newSubscriptions)
            
        } catch {
            print("Failed product request: \(error)")
        }
    }
    
    func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            // Iterate through any transactions which didn't come from a direct call to 'purchase()'
            for await result in Transaction.updates {
                do {
                    let transaction : Transaction = try self.checkVerified(result)
                    
                    // Deliver content to the user
                    await self.updatePurchasedIdentifiers(transaction)
                    
                    // Always finish a transaction
                    await transaction.finish()
                    
                } catch {
                    print("Transaction failed verification")
                }
            }
        }
    }
    
    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        // Check if the transaction passes StoreKit verification.
        switch result {
        case .unverified:
            // StoreKit has parsed the JWS but failed verification. Don't deliver content to the user.
            throw StoreError.failedVerification
        case .verified(let safe):
            // Transaction is verified, unwrap and return it.
            return safe
        }
    }
    
    func purchase(_ product: Product) async throws -> Transaction? {
        // Begin a purchase
        let result = try await product.purchase()
        
        switch result {
        case .success(let verification):
            let transaction : Transaction = try checkVerified(verification)
            
            // Deliver content to the user.
            await updatePurchasedIdentifiers(transaction)
            
            // Always finish a transaction
            await transaction.finish()
            
            return transaction
            
        case .userCancelled, .pending:
            return nil
            
        default:
            return nil
        }
    }
    
    @MainActor
    func updatePurchasedIdentifiers(_ transaction: Transaction) async {
        if transaction.revocationDate == nil {
            // If the App Store has not revoked the transaction, add it to the list of 'purchasedIdentifiers'.
            purchasedIdentifiers.insert(transaction.productID)
        } else {
            // If the App Store has revoked this transaction, remove it from the list of 'purchasedIdentifiers'.
            purchasedIdentifiers.remove(transaction.productID)
        }
    }
    
    func isPurchased(_ productIdentifier: String) async throws -> Bool {
        
        // Get the most recent transaction receipt for this 'productIdentifier'.
        guard let result = await Transaction.latest(for: productIdentifier) else {
            // If there is no latest transaction, the product has not been purchased.
            return false
        }
        
        let transaction = try checkVerified(result)
        
        // Ignore revoked transactions, they're no longer purchased.
        
        // For subscriptions, a user can upgrade in the middle of their subscription period. The lower service tier will then have the 'isUpgraded' flag set and there will be a new transaction for the higher service tier. Ignore the lower service tier transactions which have been upgraded.
        return transaction.revocationDate == nil && !transaction.isUpgraded
    }
    
    func emoji(for productId: String) -> String {
        return productIdToEmoji[productId] ?? "⭐️"
    }
    
    func sortByPrice(_ products: [Product]) -> [Product] {
        products.sorted(by: { return $0.price < $1.price })
    }
}
