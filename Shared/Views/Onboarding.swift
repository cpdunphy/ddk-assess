//
//  Onboarding.swift
//  Diadochokinetic Assess (iOS)
//
//  Created by Collin Dunphy on 12/2/21.
//

import SwiftUI
import StoreKit

struct Onboarding: View {
    var body: some View {
        GeometryReader { geo in
            VStack {
                Text("DDK")
                    .font(.system(.largeTitle, design: .rounded))
                    .bold()
                    .foregroundColor(.white)
                
                TabView {
                    VStack {
                        Text("Unlock All Access")
                            .font(.system(.title3, design: .rounded))
                            .fontWeight(.semibold)
                        
                        Text("Whether its for personal or professional use, DDK can provide support in numerous ways.")
                            
                        Spacer()
                        
                        Image(systemName: "hand.tap")
                            .font(.system(size: 96))
                            .symbolVariant(.fill)
                            .padding()
                            .background(.black.opacity(0.18), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                        
                        Spacer()
                    }
                    .foregroundColor(.white)
                    .scenePadding()
                    .frame(width: geo.size.width)
                    
                    Text("Beep")
                        .scenePadding()
                    
                    Text("Boop")
                        .scenePadding()
                }
                .tabViewStyle(.page)
                .frame(width: geo.size.width)
                
                VStack(spacing: 16) {
                    Text("Start with a 1 month free trial.")
                        .font(.headline)
                        .foregroundColor(.accentColor)
                    
                    VStack {
                        Button {
                            
                        } label: {
                            Text("Subscribe for $2.99 / year")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .padding(4)
                                .padding(.horizontal)
                        }
                        .buttonStyle(.borderedProminent)
                        
                        Text("(12 months at $0.25/mo. Save 75%)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Text("[Terms of Service](https://ballygorey.com) and [Privacy Policy](https://ballygorey.com)")
                        .font(.subheadline)
                    
                    Button("Redeem Code", action: {
                        SKPaymentQueue.default().presentCodeRedemptionSheet()
                    })
                        .padding(.vertical)
                    
                    Button("Restore Purchases", action: {})
                    
                }
                .scenePadding()
                .frame(maxWidth: .infinity, minHeight: .leastNonzeroMagnitude)
                .background(.thinMaterial)
                
            }
//            .background(.ultraThinMaterial)
            
            .background(
                Image("Background-V1")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
            )
        }
    }
}

struct Onboarding_Previews: PreviewProvider {
    static var previews: some View {
        Onboarding()
    }
}
