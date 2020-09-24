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
    var duration: Double
}

enum PossibleCountingStates {
    case ready
    case counting
    case paused
    case finished
    case countdown
}

enum ActiveAlert {
    case none
    case buying
    case email
    case review
}

enum TimeUnits : String {
    case seconds = "sec"
    case minutes = "min"
    case hours = "hour"
    case days = "day"
}
