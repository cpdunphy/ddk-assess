//
//  Record.swift
//  Diadochokinetic Assess
//
//  Created by Collin Dunphy on 9/23/20.
//

import Foundation

struct AssessmentRecord : Identifiable, Codable, Hashable {
    var id = UUID()
    var date: Date
    var taps: Int
    var type: AssessmentType
    var duration: Double
    
    var durationDescription: String {
    
        let seconds = duration.truncatingRemainder(dividingBy: 60)
        var deciseconds : String = (seconds - floor(seconds)).clean
        
        deciseconds = deciseconds == "1.0" ? "" : String(deciseconds.dropFirst(1))
        
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional // Use the appropriate positioning for the current locale
        formatter.allowedUnits = [ .minute, .second] // Units to display in the formatted string
        formatter.zeroFormattingBehavior = [ .pad ] // Pad with zeroes where appropriate for the locale
        
        return "\(formatter.string(from: duration) ?? "00:00")\(deciseconds)"
        
        
    }
}
