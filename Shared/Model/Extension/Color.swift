//
//  Color.swift
//  Diadochokinetic Assess
//
//  Created by Collin Dunphy on 9/25/20.
//

import Foundation
import SwiftUI

extension Color {
    
    static public var progressLightColor : Color {
        Color(#colorLiteral(red: 0.2784313725, green: 0.8274509804, blue: 0.7764705882, alpha: 1))
    }
    
    static public var progressDarkColor : Color {
        Color(#colorLiteral(red: 0.214261921, green: 0.3599105657, blue: 0.5557389428, alpha: 1))
    }
    
    static public var progressGradientColors : [Color] {
        [progressDarkColor, progressLightColor]
    }

}

extension Color {
    
    static public var tappingEnabled : Color {
        Color("tappingEnabled")
    }
    
    static public var tappingDisabled : Color {
        Color("tappingDisabled")
    }
}

// MARK: - Adjust
extension Color {
    
    func lighter(by percentage: CGFloat = 30.0) -> Color? {
        return self.adjust(by: abs(percentage) )
    }

    func darker(by percentage: CGFloat = 30.0) -> Color? {
        return self.adjust(by: -1 * abs(percentage) )
    }
    
    func adjust(by percentage: CGFloat = 30.0) -> Color? {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        #if os(macOS)
        let color : NSColor = NSColor(self)
        #else
        let color : UIColor = UIColor(self)
        #endif
        
        #if os(macOS)
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        let newRed = min(red + percentage/100, 1.0)
        let newGreen = min(green + percentage/100, 1.0)
        let newBlue = min(blue + percentage/100, 1.0)
        
        return Color(NSColor(
            red: newRed,
            green: newRed,
            blue: newRed,
            alpha: alpha
        ))
        #else
        if color.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            
            let newRed = min(red + percentage/100, 1.0)
            let newGreen = min(green + percentage/100, 1.0)
            let newBlue = min(blue + percentage/100, 1.0)
            
            return Color(UIColor(
                red: newRed,
                green: newGreen,
                blue: newBlue,
                alpha: alpha
            ))
        }
        #endif
        
        return nil
    }
}
