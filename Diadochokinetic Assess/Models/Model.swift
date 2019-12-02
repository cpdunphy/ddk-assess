//
//  Model.swift
//  Count-My-Taps
//
//  Created by Collin on 11/29/19.
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
