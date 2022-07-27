//
//  ProductOption.swift
//  Diadochokinetic Assess
//
//  Created by Collin Dunphy on 3/10/22.
//

import SwiftUI
import StoreKit

struct ProductOption : View {
    
    var option: Product
    @Binding var selection: Product?
    
    var body: some View {
        VStack(alignment: .leading) {
            
            HStack {
                Text(recurrenceDiscription)
                    .kerning(3)
                    .foregroundColor(.secondary)
                    .textCase(.uppercase)
                    .font(.subheadline)
                
                Spacer()
                
                ZStack {
                    Group {
                        if selection?.id == option.id {
                            ZStack {
                                Circle()
                                    .foregroundColor(Color.accentColor)
                                
                                Circle()
                                    .foregroundColor(Color.white)
                                    .frame(width: 10, height: 10)
                            }
                        }
                    }
                        .transition(.scale)
                    
                    Circle()
                        .strokeBorder(.quaternary, lineWidth: 1)
                }
                .frame(width: 25, height: 25)
            }
            
            
            Text("\(option.displayPrice)/\(recurrence)")
                .font(.title3)
                .fontWeight(.medium)
            
            if let offer = option.subscription?.introductoryOffer {
                    
                //TODO: Make this more robust
                Text("\(offer.periodCount) \(offer.period.unit.debugDescription) \(offer.price.isZero ? "Free" : offer.displayPrice) Trial")
                        .foregroundColor(.green)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .padding(5)
                        .background(Color.green.opacity(0.15))
                        .cornerRadius(4)
            }
            
            Text("then \(option.displayPrice) per \(recurrence). Cancel anytime.")
                .foregroundColor(.secondary)
        }
    }
    
    var recurrenceDiscription : String {
        switch option.subscription?.subscriptionPeriod.unit {
        case .year:
            return "Anually"
        case .month:
            return "Monthly"
        case .week:
            return "Weekly"
        case .day:
            return "Daily"
        default:
            return "Recurring"
        }
    }
    
    var recurrence : String {
        let unit : String = (option.subscription?.subscriptionPeriod.value ?? -1) == 1 ? "" : "\(option.subscription?.subscriptionPeriod.value ?? -1)"
        return (unit) + (option.subscription?.subscriptionPeriod.unit.debugDescription ?? "Unknown").lowercased()
    }
}


//struct ProductOption_Previews: PreviewProvider {
//
//    static var previews: some View {
////        ProductOption(product: selected: true)
////            .scenePadding()
//    }
//}
