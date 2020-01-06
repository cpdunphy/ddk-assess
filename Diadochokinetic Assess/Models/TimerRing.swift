//
//  TimerRing.swift
//  Diadochokinetic Assess
//
//  Created by Collin on 12/1/19.
//  Copyright © 2019 Ballygorey Apps. All rights reserved.
//

import Foundation
import SwiftUI

struct TimerRing: Shape {
  var percent: Double

  func path(in rect: CGRect) -> Path {
    let end = percent * 360
    var p = Path()
    
    p.addArc(center: CGPoint(x: rect.size.width/2, y: rect.size.width/2),
             radius: rect.size.width/2,
             startAngle: Angle(degrees: 1),
             endAngle: Angle(degrees: end),
             clockwise: false)
//    p.fill()
    return p
  }
  
  var animatableData: Double {
    get { return percent }
    set { percent = newValue }
  }
}


struct LittleDash : Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        
        p.move(to: CGPoint(x: rect.minX, y: rect.midY))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        
        return p
    }
}


struct Handle : View {
    private let handleThickness = CGFloat(4.5)
    var body: some View {
        RoundedRectangle(cornerRadius: handleThickness / 2.0)
            .frame(width: 70, height: handleThickness)
            .foregroundColor(Color.gray)
        
    }
}
	
