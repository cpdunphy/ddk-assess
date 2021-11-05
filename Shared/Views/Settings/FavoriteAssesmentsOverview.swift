//
//  FavoriteAssesmentsOverview.swift
//  Diadochokinetic Assess (iOS)
//
//  Created by Collin Dunphy on 11/5/21.
//

import SwiftUI

struct FavoriteAssesmentsOverview : View {
    
    @EnvironmentObject var ddk : DDKModel
    
    var body: some View {
        Form {
            ForEach(AssessmentType.allCases, id: \.self) { type in
                favoriteToggle(type)
            }
        }
        .navigationTitle("Edit Favorites")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func favoriteToggle(_ type: AssessmentType) -> some View {
        Toggle(
            isOn: Binding<Bool>(
                get: {
                    ddk.assessmentTypeIsFavorite(type)
                },
                set: { newValue in
                    ddk.toggleFavoriteStatus(type)
                }
            ),
            label: {
                Label(
                    title: {
                        Text(type.title)
                    },
                    icon: {
                        Image(systemName: type.icon)
                            .symbolVariant(.fill)
                            .foregroundColor(type.color)
                    }
                )
            }
        )
    }
}

struct FavoriteAssesmentsOverview_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteAssesmentsOverview()
    }
}
