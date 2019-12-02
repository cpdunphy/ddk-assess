//
//  TapViewController.swift
//  Diadochokinetic Assess
//
//  Created by Collin on 12/1/19.
//  Copyright © 2019 Ballygorey Apps. All rights reserved.
//

import SwiftUI

struct TapViewController: View {
    @EnvironmentObject var timerSession: TimerSession
    var body: some View {
        ZStack {
            if timerSession.timedModeActive {
                TimedTapView().environmentObject(timerSession)
            } else {
                UntimedTapView().environmentObject(timerSession)
            }
        }
    }
}

struct TapViewController_Previews: PreviewProvider {
    static var previews: some View {
        TapViewController()
    }
}

