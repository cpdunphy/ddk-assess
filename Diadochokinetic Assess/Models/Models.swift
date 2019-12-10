//
//  Model.swift
//  Diadochokinetic Assess
//
//  Created by Collin on 12/1/19.
//  Copyright © 2019 Ballygorey Apps. All rights reserved.
//

import Foundation

struct Record : Identifiable, Hashable {
    var id = UUID()
    var date: Date
    var taps: Int
    var timed: Bool
    var duration: Int
}

enum PossibleCountingStates {
    case ready
    case counting
    case paused
    case finished
    case countdown
}
