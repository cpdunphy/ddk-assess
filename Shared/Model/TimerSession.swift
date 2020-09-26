//
//  TimerSession.swift
//  Diadochokinetic Assess
//
//  Created by Collin Dunphy on 9/25/20.
//

import Foundation
import Combine

// MARK: - TimerSession

class TimerSession : ObservableObject {
    
    private var timer : AnyCancellable?

    @Published var currentDateTime : Date = Date()

    init() {
        self.timer = Timer.publish(every: 0.1, on: .main, in: .default)
            .autoconnect()
            .sink(receiveValue: { time in
                self.currentDateTime = time
            })
    }
    
}
