//
//  Color.swift
//  Diadochokinetic Assess
//
//  Created by Collin Dunphy on 9/25/20.
//

import Foundation
import SwiftUI

extension Color {

    func lighter(by percentage: CGFloat = 30.0) -> Color? {
        return self.adjust(by: abs(percentage))
    }

    func darker(by percentage: CGFloat = 30.0) -> Color? {
        return self.adjust(by: -1 * abs(percentage))
    }

    func adjust(by percentage: CGFloat = 30.0) -> Color? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        let color: UIColor = UIColor(self)

        if color.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {

            let newRed = min(red + percentage / 100, 1.0)
            let newGreen = min(green + percentage / 100, 1.0)
            let newBlue = min(blue + percentage / 100, 1.0)

            return Color(
                UIColor(
                    red: newRed,
                    green: newGreen,
                    blue: newBlue,
                    alpha: alpha
                ))
        }

        return nil
    }
}
