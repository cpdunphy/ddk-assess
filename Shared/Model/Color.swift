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
