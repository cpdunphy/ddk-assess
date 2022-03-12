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
                Text("Monthly")
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
            
            
            Text("\(option.displayPrice)/month")
                .font(.title3)
                .fontWeight(.medium)
            
            Text("1 Week Free Trial")
                .foregroundColor(.green)
                .font(.subheadline)
                .fontWeight(.semibold)
                .padding(5)
                .background(Color.green.opacity(0.15))
                .cornerRadius(4)
            
            Text("then \(option.displayPrice) per month. Cancel anytime.")
                .foregroundColor(.secondary)
        }
    }
}


//struct ProductOption_Previews: PreviewProvider {
//
//    static var previews: some View {
////        ProductOption(product: selected: true)
////            .scenePadding()
//    }
//}
