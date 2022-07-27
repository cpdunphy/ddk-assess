//
//  AssessmentProtocol.swift
//  Diadochokinetic Assess (iOS)
//
//  Created by Collin Dunphy on 3/7/22.
//

import Foundation
import SwiftUI

protocol AssessmentProtocol {

     // ID
     var id : String { get }

     // Type that the Assessment Model is Representing
     var type : AssessmentType { get }

     // Current Date & Time
     var currentDateTime : Date { get }

     // Assessment Display Name
     var title : String { get }

     // Icon Color
     var color: Color { get }

     // System Icon Glyph
     var symbol : String { get }

     // Date & Time the tracker was last used
     var dateLastUsed : Date { get set }



     // Preferences
     
     // Preference: Show the decimal on the timer
     var showDecimalOnTimer : Bool { get set }

     // Reset Preferences
     func resetPreferences()
 }
