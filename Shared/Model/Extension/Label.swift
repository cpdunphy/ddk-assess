//
//  Label.swift
//  DDK
//
//  Created by Collin Dunphy on 10/1/25.
//

import Foundation
import SwiftUI

struct IconTintLabelStyle: LabelStyle {
    let color: Color
    let secondary: Color?

    init(_ color: Color) {
        self.color = color
        self.secondary = nil
    }

    func makeBody(configuration: Configuration) -> some View {
        Label {
            configuration.title  // The text part of the label
        } icon: {
            configuration.icon
                .foregroundStyle(color)
        }
    }
}

extension LabelStyle where Self == IconTintLabelStyle {
    static func iconTint(_ color: Color) -> IconTintLabelStyle {
        IconTintLabelStyle(color)
    }
}
