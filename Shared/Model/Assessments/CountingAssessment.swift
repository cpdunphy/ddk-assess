//
//  CountingAssessment.swift
//  Diadochokinetic Assess (iOS)
//
//  Created by Collin Dunphy on 11/2/21.
//

import Foundation

class CountingAssessment : Assessment {
    
    @Published var taps : Int = 0
    
    init() {
        super.init(.count)
    }
}
