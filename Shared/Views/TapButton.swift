//
//  TapButton.swift
//  Diadochokinetic Assess
//
//  Created by Collin Dunphy on 9/25/20.
//

import SwiftUI
#if !os(macOS)
import UIKit
#endif

struct TapButton: View {
    @EnvironmentObject var timerSession: TimerSession
    @EnvironmentObject var model : DDKModel

    #if os(iOS)
    let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .light)
    #endif
    var body : some View {
        if model.currentTimedState == .counting || model.assessType == .count {
            
            Button(action: handleTaps) {
                getButtonImage
            }
            .buttonStyle(PlainButtonStyle())
            
        } else {
            getButtonImage
        }
    }
    
    var getButtonImage : some View {
        Text(getText)
            .font(.system(size: 50, weight: .semibold, design: .rounded))
            .foregroundColor(model.currentTimedState != .counting && model.assessType == .timed ? Color(#colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)) : Color(#colorLiteral(red: 0.8640799026, green: 0.8640799026, blue: 0.8640799026, alpha: 1)))
//            .frame(minWidth: 150, idealWidth: 300, maxWidth: 500, minHeight: 150, idealHeight: 300, maxHeight: 500)
        .frame(minWidth: 200, maxWidth: .infinity, minHeight: 200, maxHeight: .infinity)
            .background(getBackgroundColor)
            .cornerRadius(15)
//            .shadow(radius: model.currentTimedState != .counting && model.assessType == .timed ? 0 : 2)
//        ContainerRelativeShape()
//            .inset(by: 0)
//            .foregroundColor(getBackgroundColor)
    }
    
    func handleTaps() {
        model.handleTaps()
        
        #if os(iOS)
        self.impactFeedbackgenerator.prepare()
        self.impactFeedbackgenerator.impactOccurred()
        #endif
    }
    
    var getBackgroundColor : Color {
        switch model.assessType {
        case .timed:
            return model.currentTimedState == .counting ? Color("tappingEnabled") : Color("tappingDisabled")
        case .count:
            return Color("tappingEnabled")
        }
    }
    
    var getText : String {
        switch model.assessType {
        case .timed:
            return model.currentTimedState == .counting ? "Tap!" : "Disabled"
        case .count:
            return "Tap!"
        }
    }
}

struct TapButton_Previews: PreviewProvider {
    static var previews: some View {
        TapButton()
    }
}
