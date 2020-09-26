//
//  Record.swift
//  Diadochokinetic Assess
//
//  Created by Collin Dunphy on 9/23/20.
//

import Foundation

struct Record : Identifiable, Hashable {
    var id = UUID()
    var date: Date
    var taps: Int
    var timed: Bool
    var duration: Int
}
