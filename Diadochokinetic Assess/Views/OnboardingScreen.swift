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
                }.padding([.top, .bottom])
                Spacer()
                
                VStack(alignment: .leading) {
                    OnboardingRow(
                        title: "Time and Tap",
                        imageName: "timer",
                        description: "Set a custom countdown timer and track \"Puh-Tuh-Kuhs\" with taps."
                    ).padding(.bottom)
                    OnboardingRow(
                        title: "Count your taps",
                        imageName: "stopwatch.fill",
                        description: "Count the number of \"Puh-Tuh-Kuhs\" with taps over time."
                    ).padding(.bottom)
                    OnboardingRow(
                        title: "History",
                        imageName: "book.fill",
                        description: "View recent history."
                    ).padding(.bottom)

                }
                
                Spacer()
                Text("Ballygorey Apps do not collect nor store any PHI and PII that may be generated while using the app.")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                Spacer()
                
                Button(action: {
                    withAnimation(.default) {
                        self.showOnboardingScreen = false
                        defaults.set(false, forKey: showOnboardingKey)
                    }
                    print("onboarding complete")
                }) {
                    Text("Start Assessing DKK Now")
                        .font(.headline)
                        .frame(width: UIScreen.main.bounds.width * 0.82, height: UIScreen.main.bounds.height * 0.08)
                        .background(accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(7)
                }
            }.frame(width: UIScreen.main.bounds.width * 0.82, height: UIScreen.main.bounds.height * 0.9)
        }
    }
    
    struct OnboardingRow : View {
        var title : String
        var imageName : String
        var description: String
        var accentColor = Color("AccentColor")

        var body : some View {
            ZStack {
                HStack {
                    Image(systemName: imageName)
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(accentColor)
                        .frame(width: UIScreen.main.bounds.width * 0.1)
                        .padding(.trailing)
        //            Spacer()
                    VStack(alignment: .leading) {
                        Text(title)
                            .bold()
                            
                        Text(description)
                    }
                    Spacer()
                }
            }.frame(width: UIScreen.main.bounds.width * 0.82)//, height: UIScreen.main.bounds.height*0.15)
        }
    }
}


