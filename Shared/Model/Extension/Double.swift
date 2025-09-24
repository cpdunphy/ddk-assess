//
//  Double.swift
//  Diadochokinetic Assess (iOS)
//
//  Created by Collin Dunphy on 3/8/22.
//

import Foundation

extension Double {
    var clean: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(format: "%.1f", self)
    }
}
