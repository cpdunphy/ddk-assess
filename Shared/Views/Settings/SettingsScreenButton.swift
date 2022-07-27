//
//  SettingsScreenButton.swift
//  Diadochokinetic Assess
//
//  Created by Collin Dunphy on 10/17/21.
//

import SwiftUI

struct SettingsScreenButton: View {
    
    var title: String?
    var symbolSystemName: String?
    var imageName: String?
    var symbolColor: Color?
        
    @Environment(\.colorScheme) var colorScheme : ColorScheme
    
    var body: some View {
        Label(
            title: {
                if let title = title {
                    Text(title)
                        .foregroundColor(.primary)
                }
            },
            icon: {
                image
            }
        )
    }
    
    @ScaledMetric(wrappedValue: 35, relativeTo: .title3) var imageIconSize : CGFloat
    
    @ViewBuilder
    var image : some View {
        if let symbol = symbolSystemName {
            Image(systemName: symbol)
                .foregroundStyle(symbolColor ?? .primary, .primary)
                .font(.title3)
        }
        else if let image = imageName {
            Image(image)
                .resizable()
                .frame(width: imageIconSize, height: imageIconSize)
        }
    }
}

struct SettingsScreenButton_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreenButton()
    }
}
