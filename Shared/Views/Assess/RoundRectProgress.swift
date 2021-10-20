//
//  RoundRectProgress.swift
//  Diadochokinetic Assess (iOS)
//
//  Created by Collin Dunphy on 10/15/21.
//

import Foundation
import SwiftUI

struct RoundedRectProgress : InsettableShape {
    var insetAmount: CGFloat = 0
    
    var cornerRadius: CGFloat = 15
    var clockwise : Bool = false
    
    func path(in rect: CGRect) -> Path {
        
        let startingPointWithOffset: CGPoint = CGPoint(x: rect.midX + insetAmount, y: rect.minY + insetAmount)
        
        let topRightCorner: CGPoint = CGPoint(x: rect.maxX, y: rect.minY)
        let bottomRightCorner: CGPoint = CGPoint(x: rect.maxX , y: rect.maxY)
        let bottomLeftCorner: CGPoint = CGPoint(x: rect.minX, y: rect.maxY)
        let topLeftCorner: CGPoint = CGPoint(x: rect.minX, y: rect.minY)
        
        let topRightCornerWithInset = CGPoint(x: topRightCorner.x - insetAmount, y: topRightCorner.y + insetAmount)
        let bottomRightCornerWithInset = CGPoint(x: bottomRightCorner.x - insetAmount, y: bottomRightCorner.y - insetAmount)
        let bottomLeftCornerWithInset = CGPoint(x: bottomLeftCorner.x + insetAmount, y: bottomLeftCorner.y - insetAmount)
        let topLeftCornerWithInset = CGPoint(x: topLeftCorner.x + insetAmount, y: topLeftCorner.y + insetAmount)
        
        let topRightCornerLineStart = CGPoint(x: topRightCornerWithInset.x - cornerRadius, y: topRightCornerWithInset.y)
        let bottomRightCornerLineStart = CGPoint(x: bottomRightCornerWithInset.x, y: bottomRightCornerWithInset.y - cornerRadius)
        let bottomLeftCornerLineStart = CGPoint(x: bottomLeftCornerWithInset.x + cornerRadius, y: bottomLeftCornerWithInset.y)
        let topLeftCornerLineStart = CGPoint(x: topLeftCornerWithInset.x, y: topLeftCornerWithInset.y + cornerRadius)
        
        let topRightArcCenter : CGPoint = CGPoint(x: topRightCornerWithInset.x - cornerRadius, y: topRightCornerWithInset.y + cornerRadius)
        let bottomRightArcCenter : CGPoint = CGPoint(x: bottomRightCornerWithInset.x - cornerRadius, y: bottomRightCornerWithInset.y - cornerRadius)
        let bottomLeftArcCenter : CGPoint = CGPoint(x: bottomLeftCornerWithInset.x + cornerRadius, y: bottomLeftCornerWithInset.y - cornerRadius)
        let topLeftArcCenter : CGPoint = CGPoint(x: topLeftCornerWithInset.x + cornerRadius, y: topLeftCornerWithInset.y + cornerRadius)
        
        var p = Path()
        
        p.move(to: startingPointWithOffset)
        p.addLine(to: topRightCornerLineStart)
        p.addArc(center: topRightArcCenter, radius: cornerRadius, startAngle: .degrees(-90), endAngle: .degrees(0), clockwise: clockwise, transform: .identity)
        p.addLine(to: bottomRightCornerLineStart)
        p.addArc(center: bottomRightArcCenter, radius: cornerRadius, startAngle: .degrees(0), endAngle: .degrees(90), clockwise: clockwise, transform: .identity)
        p.addLine(to: bottomLeftCornerLineStart)
        p.addArc(center: bottomLeftArcCenter, radius: cornerRadius, startAngle: .degrees(90), endAngle: .degrees(180), clockwise: clockwise, transform: .identity)
        p.addLine(to: topLeftCornerLineStart)
        p.addArc(center: topLeftArcCenter, radius: cornerRadius, startAngle: .degrees(180), endAngle: .degrees(270), clockwise: clockwise, transform: .identity)
        p.addLine(to: startingPointWithOffset)
        return p
    }
    
    
    func inset(by amount: CGFloat) -> some InsettableShape {
        var rect = self
        rect.insetAmount += amount
        return rect
    }
}
