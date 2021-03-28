//
//  AssessScreen.swift
//  Diadochokinetic Assess
//
//  Created by Collin Dunphy on 1/6/21.
//

import SwiftUI

struct AssessScreen : View {
    
    @EnvironmentObject var model : DDKModel
        
    var body : some View {
        assess
            .background(
                Color(.systemGroupedBackground)
                    .edgesIgnoringSafeArea(.all)
            )
            .toolbar {
                ToolbarItem(placement: ToolbarItemPlacement.navigationBarTrailing) {
                    AssessmentPicker()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(NavigationItem.assess.title)
    }
    
    var assess : some View {
        VStack(spacing: 16) {
            StatsDisplay()
                .layoutPriority(1)
            TapButton()
                .layoutPriority(1)
        }
        .padding(16)
    }
}


struct AssessScreen_Previews: PreviewProvider {
    static var previews: some View {
        AssessScreen()
    }
}
