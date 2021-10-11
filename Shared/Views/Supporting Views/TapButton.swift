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
        if model.currentTimedState == [.counting] || model.assessType == .count {
            
            Button(action: handleTaps) {
                buttonTapArea
            }
            .buttonStyle(PlainButtonStyle())
            
        } else {
            buttonTapArea
        }
    }
    
    @ScaledMetric(relativeTo: .largeTitle) var buttonLabelTextSize: CGFloat = 50

    var buttonTapArea : some View {
        Text(getText)
            .font(.system(size: buttonLabelTextSize, weight: .semibold, design: .rounded))
            .foregroundColor(
                model.currentTimedState != [.counting] && model.assessType == .timed ?
                    Color.gray.opacity(0.75) :
                    .white
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(getBackgroundColor)
    }
    
    /// Calls the handleTaps on model and sending the haptic feedback to the user. Called each time theres a tap and lets the DDKModel figure out what to do with it. 
    func handleTaps() {
        model.handleTaps()
        
        #if os(iOS)
        self.impactFeedbackgenerator.prepare()
        self.impactFeedbackgenerator.impactOccurred()
        #endif
    }
    
    /// Gets the background color for the assess button. Using a switch statement for future-proofing
    var getBackgroundColor : Color {
        switch model.assessType {
        case .timed:
            return model.currentTimedState == [.counting] ? .tappingEnabled : .tappingDisabled
        case .count:
            return .tappingEnabled
        }
    }
    
    /// Gets the display label for the assess button. Using a switch statement for future-proofing
    var getText : String {
        switch model.assessType {
        case .timed:
            return model.currentTimedState == [.counting] ? "Tap!" : "Disabled"
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
