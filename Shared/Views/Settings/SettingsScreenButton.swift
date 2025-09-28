//
//  SettingsScreenButton.swift
//  Diadochokinetic Assess
//
//  Created by Collin Dunphy on 10/17/21.
//

import SwiftUI

struct SettingsScreenButton: View {

    var title: String
    var symbolSystemName: String
    var imageName: String?
    var symbolColor: Color?

    @Environment(\.colorScheme) var colorScheme: ColorScheme

    var body: some View {
        Label(
            title: {
                Text(title)
                    .foregroundColor(.primary)
            },
            icon: {
                Image(systemName: symbolSystemName)
                    .foregroundStyle(symbolColor ?? .primary, .primary)
                    .font(.title3)
            }
        )
    }

    @ScaledMetric(wrappedValue: 35, relativeTo: .title3) var imageIconSize: CGFloat
}

struct SettingsScreenButton_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreenButton(title: "Test", symbolSystemName: "heart.fill")
    }
}
