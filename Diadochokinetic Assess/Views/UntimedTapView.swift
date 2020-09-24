//
//  UntimedTapView.swift
//  Diadochokinetic Assess
//
//  Created by Collin on 12/1/19.
//  Copyright © 2019 Ballygorey Apps. All rights reserved.
//

import SwiftUI

struct UntimedTapView: View {
    @EnvironmentObject var timerSession : TimerSession
    var body: some View {
        ZStack {
            Color("background").edgesIgnoringSafeArea([.top, .bottom])
        VStack {
            ZStack {
                BackgroundRect()
                    .frame(width: Screen.width * 0.8, height: Screen.height * 0.3)
                UntimedCenterText()
                    .frame(width: Screen.width * 0.8, height: min(Screen.height * 0.3, 175))
                Handle().offset(CGSize(width: 0, height: 15))
            }.frame(width: Screen.width, height: Screen.height * 0.3)//.padding(.bottom)
            
            HStack {
            
                Button(action: {
                    self.timerSession.stopUntimed()
                }) {
                    resetButton
                }
                Spacer()
                Button(action: {
                    self.timerSession.finishAndLogUntimed()
                }) {
                    logButton
                }
                
            }
            .frame(height: Screen.width*0.25)
            .padding([.leading, .trailing], Screen.width * 0.09)
            
//            Button("Tap") {
//                startTime = Date()
//            }
            TapButton(timed: false).environmentObject(timerSession)//.padding(.top, -10)
            }
        }
    }
    func BackgroundRect() -> some View {
        Rectangle()
        .foregroundColor(Color("RectangleBackground"))
            .cornerRadius(15)
    }
    
//    @State private var startTime : Date = Date()
    
    func UntimedCenterText() -> some View {
        VStack {
            Text("\(timerSession.unTimedTaps) \(timerSession.unTimedTaps == 1 ? "tap" : "taps")")
                .font(.custom("Nunito-Bold", size: 50))
                .padding(.bottom)
            Text(timerSession.getStandardTimeDisplayString(time: timerSession.currentUntimedCount))
//            Text(startTime.addingTimeInterval(startTime.distance(to: Date())), style: .timer)
                .font(.custom("Nunito-SemiBold", size: 22))
//            Text("\(timerSession.currentUntimedCount)")
//                .font(.custom("Nunito-SemiBold", size: 22))

        }
    }
}

struct UntimedTapView_Previews: PreviewProvider {
    static var previews: some View {
        UntimedTapView()
        .environmentObject(TimerSession())
    }
}
