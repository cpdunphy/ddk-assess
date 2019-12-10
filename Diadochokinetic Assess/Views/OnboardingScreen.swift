//
//  OnboardingScreen.swift
//  Starting Screen
//
//  Created by Collin on 12/1/19.
//  Copyright © 2019 Ballygorey Apps. All rights reserved.
//

import SwiftUI
struct OnboardingScreen: View {
    var accentColor = Color("AccentColor")
    @Binding var showOnboardingScreen: Bool
    var body: some View {
        
        ZStack {
            Color("background").edgesIgnoringSafeArea([.top, .bottom])
            VStack(alignment: .leading) {
                Spacer()
                VStack(alignment: .leading) {
                    Text("Welcome")
                        .font(.largeTitle)
                        .fontWeight(.black)
                    HStack {
                        Text("to")
                            .font(.largeTitle)
                            .fontWeight(.black)
                        Text("DDK")
                            .font(.largeTitle) //Make slightly larger than "Welcome to"
                            .fontWeight(.black)
                            .foregroundColor(accentColor)
                    }
                }.padding(.bottom, 20)

                
                
                OnboardingRow(
                    title: "More Personalized",
                    imageName: "timer",
                    description: "Top Stories picked for you and recommendations from Siri."
                )
                OnboardingRow(
                    title: "More Personalized",
                    imageName: "hand.draw.fill",
                    description: "Top Stories picked for you and recommendations from Siri."
                )
                OnboardingRow(
                    title: "More Personalized",
                    imageName: "rectangle.stack.person.crop.fill",
                    description: "Top Stories picked for you and recommendations from Siri."
                )
                
                Spacer()
                
                VStack(alignment: .center, spacing: 7) {
                    Text("Ballygorey Apps does not collect nor store any patient data that may be generated while using the app.")
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                    Button(action: {
                        //TODO: Send to privacy page.
                    }) {
                        Text("DDK and Privacy")
                        .foregroundColor(accentColor)
                    }.disabled(true)
                }//.frame(width: UIScreen.main.bounds.width * 0.75)
                
                Spacer()
                Button(action: {
                    self.showOnboardingScreen = false
                    defaults.set(true, forKey: showOnboardingKey)
                }) {
                    Text("Start Assessing DKK Now")
                        .font(.headline)
                        .frame(width: UIScreen.main.bounds.width * 0.82, height: UIScreen.main.bounds.height * 0.07)
                        .background(accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(7)
                }
            }.frame(width: UIScreen.main.bounds.width * 0.82, height: UIScreen.main.bounds.height * 0.9)
        }
    }
}

struct OnboardingRow : View {
    var title : String
    var imageName : String
    var description: String
    var accentColor = Color("AccentColor")

    var body : some View {
        HStack {
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .foregroundColor(accentColor)
                .frame(width: UIScreen.main.bounds.width * 0.1)

            Spacer()
            VStack(alignment: .leading) {
                Text(title)
                    .bold()
                    
                Text(description)
            }
        }.frame(width: UIScreen.main.bounds.width * 0.82, height: UIScreen.main.bounds.height*0.1)
    }
}
