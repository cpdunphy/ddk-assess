//
//  Assessment.swift
//  Diadochokinetic Assess (iOS)
//
//  Created by Collin Dunphy on 11/2/21.
//

import Combine
import Foundation
import SwiftUI

class Assessment : ObservableObject {
    
    var type : AssessmentType
    
    private var timer : AnyCancellable?
    @Published var currentDateTime : Date = .now
    
    init(_ type: AssessmentType) {
        self.type = type
        self.timer = Timer.publish(every: 0.1, on: .main, in: .default)
            .autoconnect()
            .sink(receiveValue: { time in
                self.currentDateTime = time
            })
    }
    
    var title: String {
        type.title
    }
    
    var color: Color {
        type.color
    }
    
    var symbol: String {
        type.icon
    }
    
    var id: String {
        return title
    }
    
}
