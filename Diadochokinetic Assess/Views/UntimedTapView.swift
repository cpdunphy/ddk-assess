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
        VStack {
            ZStack {

                Rectangle()
                    .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.3)
                .foregroundColor(Color("RectangleBackground"))
                    .cornerRadius(15)
                VStack {
                    Text("\(timerSession.unTimedTaps) \(timerSession.unTimedTaps == 1 ? "tap" : "taps")")
                        .font(.system(size: 60))
                        .padding(.bottom)
                    Text(timerSession.getUntimedTimeString())
                        .font(.system(size: 20))
                }.frame(width: UIScreen.main.bounds.width * 0.8, height: 175)
                Handle().offset(CGSize(width: 0, height: 22))
            }.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height*0.3)
            
            HStack {
            
                Button(action: {
                    self.timerSession.stopUntimed()
                }) {
                    stopButton
                }
                
                Button(action: {
                    self.timerSession.finishAndLogUntimed()
                }) {
                    logButton
                }
            }
            
            
            TapButton(timed: false).environmentObject(timerSession)
        }
    }
}

struct UntimedTapView_Previews: PreviewProvider {
    static var previews: some View {
        UntimedTapView()
    }
}
