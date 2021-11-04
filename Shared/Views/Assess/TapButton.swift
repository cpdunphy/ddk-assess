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
    @EnvironmentObject var model : DDKModel

    @Binding var taps: Int
    var countingState : Set<CountingState>?
    var enabledStates : Array<Set<CountingState>>
    var style : AssessmentButtonStyle
    var enabledText : String = "Tap!"
    var disabledText : String = "Disabled"
    
    init(
        taps: Binding<Int>,
        countingState: Set<CountingState>? = nil,
        enabledStates: Array<Set<CountingState>> = [[.counting]],
        style: AssessmentButtonStyle? = nil,
        enabledText: String = "Tap!",
        disabledText: String = "Disabled"
    ) {
        self._taps = taps
        self.countingState = countingState
        self.enabledStates = enabledStates
        self.style = style ?? AssessmentButtonStyle()
        self.enabledText = enabledText
        self.disabledText = disabledText
    }
    
    @ScaledMetric(relativeTo: .largeTitle) var buttonLabelTextSize: CGFloat = 50
    
    #if os(iOS)
    let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    #endif
    
    /// Says if the button should be enabled or not given the current state
    var isEnabled : Bool {
        
        guard let countingState = countingState else {
            return true
        }

        return enabledStates.contains(countingState)
    }
    
    // MARK: - Body
    var body : some View {
        Button(action: handleTaps) {
            Text(displayText)
                .font(.system(size: buttonLabelTextSize, weight: .semibold, design: .rounded))
        }
        .buttonStyle(style)
        .disabled(!isEnabled)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    /// Calls the handleTaps on model and sending the haptic feedback to the user. Called each time theres a tap and lets the DDKModel figure out what to do with it. 
    func handleTaps() {
        taps += 1
        
        #if os(iOS)
        self.impactFeedbackGenerator.prepare()
        self.impactFeedbackGenerator.impactOccurred()
        #endif
    }
    
    /// Gets the display label for the assess button.
    var displayText : String {
        return isEnabled ? enabledText : disabledText
    }
    
    
    struct AssessmentButtonStyle: ButtonStyle {

        @Environment(\.isEnabled) private var isEnabled: Bool
        
        var corners: UIRectCorner = .allCorners
        
        var enabledForegroundColor : Color = .white
        var disabledForegroundColor : Color = Color.gray.opacity(0.75)
        var enabledBackgroundColor : Color = .tappingEnabled
        var disabledBackgroundColor : Color = .tappingDisabled
        
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .foregroundColor(isEnabled ? enabledForegroundColor : disabledForegroundColor)
                .background(isEnabled ? enabledBackgroundColor : disabledBackgroundColor)
                .cornerRadius(15.0, corners: corners)
                .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
                .opacity(configuration.isPressed ? 0.7 : 1.0)
        }
    }
}

struct TapButton_Previews: PreviewProvider {
    static var previews: some View {
        TapButton(taps: .constant(7))
    }
}





