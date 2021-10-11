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

    @Binding var taps: Int
    var countingState : Set<CountingState>?
    var enabledBackgroundColor : Color = .tappingEnabled
    var disabledBackgroundColor : Color = .tappingDisabled
    var enabledText : String = "Tap!"
    var disabledText : String = "Disabled"
    var enabledTextColor : Color = .white
    var disabledTextColor : Color = Color.gray.opacity(0.75)
    
    
    #if os(iOS)
    let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    #endif
    
    var body : some View {
        if let countingState = countingState {
            if countingState == [.counting] {
                Button(action: handleTaps) {
                    buttonTapArea
                }
                .buttonStyle(PlainButtonStyle())
            } else {
                buttonTapArea
            }
        } else {
            Button(action: handleTaps) {
                buttonTapArea
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    @ScaledMetric(relativeTo: .largeTitle) var buttonLabelTextSize: CGFloat = 50

    var buttonTapArea : some View {
        Text(displayText)
            .font(.system(size: buttonLabelTextSize, weight: .semibold, design: .rounded))
            .foregroundColor(textColor)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(backgroundColor)
    }
    
    /// Calls the handleTaps on model and sending the haptic feedback to the user. Called each time theres a tap and lets the DDKModel figure out what to do with it. 
    func handleTaps() {
        taps += 1
        
        #if os(iOS)
        self.impactFeedbackGenerator.prepare()
        self.impactFeedbackGenerator.impactOccurred()
        #endif
    }
    
    /// Gets the background color for the assess button.
    var backgroundColor : Color {
        
        guard let countingState = countingState else {
            return .tappingEnabled
        }
        
        return countingState == [.counting] ? .tappingEnabled : .tappingDisabled
        
    }

    /// Gets the text color for the assess button.
    var textColor : Color {
        guard let countingState = countingState else {
            return enabledTextColor
        }
        
        return countingState == [.counting] ? enabledTextColor : disabledTextColor
    }
    
    
    /// Gets the display label for the assess button.
    var displayText : String {
        guard let countingState = countingState else {
            return enabledText
        }
        
        return countingState == [.counting] ? enabledText : disabledText
    }
}

struct TapButton_Previews: PreviewProvider {
    static var previews: some View {
        TapButton(taps: .constant(7))
    }
}
