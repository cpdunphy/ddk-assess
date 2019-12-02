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
                    .frame(width: UIScreen.main.bounds.width * 0.8, height: 175)
                .foregroundColor(Color(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)))
                    .cornerRadius(15)
                Text("\(timerSession.taps) \(timerSession.taps == 1 ? "tap" : "taps")")
                    .font(.system(size: 60))
            }.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height*0.4)
            Button(action: {
                let send = Record(date: Date(), taps: self.timerSession.taps, timed: false, duration: 0)
                self.timerSession.recordingsArr.insert(send, at: 0)
                self.timerSession.taps = 0
            }) {
                Text("Log Taps")
                    .font(.title)
                    .padding()
                    .background(Color(#colorLiteral(red: 0.897414914, green: 0.6241459817, blue: 0.1333333403, alpha: 1)))
                    .cornerRadius(8)
                    .frame(height: 85)
            }
            TapButton().environmentObject(timerSession)
        }.onAppear(perform: {
            self.timerSession.countingState = .counting
        })
    }
}

struct UntimedTapView_Previews: PreviewProvider {
    static var previews: some View {
        UntimedTapView()
    }
}
