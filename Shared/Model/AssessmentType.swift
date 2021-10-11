//
//  AssessmentType.swift
//  AssessmentType
//
//  Created by Collin Dunphy on 7/17/21.
//

import Foundation
import SwiftUI

enum AssessmentType : String, Codable, CaseIterable, Identifiable {
    
    case timed
    case count
    case heartRate
    
    var title : String {
        switch self {
        case .timed:        return "Timed"
        case .count:        return "Count"
        case .heartRate:    return "Heart Rate"
        }
    }
    
    var color: Color {
        //TODO: Add these
        switch self {
        case .timed:        return .blue     //#bae1ff
        case .count:        return .orange   //#ffdfba
        case .heartRate:    return .pink     //#ffb3ba
        }
    }
    
    var icon: String {
        switch self {
        case .timed:        return "timer"
        case .count:        return "number"
        case .heartRate:    return "heart"
        }
    }
    
    var description: String {
        //TODO: Add these
        return ""
    }
    
    var id: String {
        return self.rawValue
    }
}

class Assessment : ObservableObject {
    
    var type : AssessmentType
    
    init(_ type: AssessmentType) {
        self.type = type
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
    
    var finiteTime : Bool = true
}


class TimedAssessment : Assessment {
    
    //    @Published var duration: Double = 0.0
    
}

class UntimedAssessment : Assessment {
    
    override init(_ type: AssessmentType) {
        super.init(type)
        super.finiteTime = false
    }
}


// MARK: - Actual Assessment Models

struct Keys {
    static func timerLength(_ type: AssessmentType) -> String {
        return type.rawValue + "_timer_length"
    }
    
    static func countdownLength(_ type: AssessmentType) -> String {
        return type.rawValue + "_countdown_length"
    }
}

class TimedCountingAssessment : Assessment {
    
    @Published var taps : Int = 0
    @AppStorage(Keys.timerLength(.timed)) var duration : Int = 10
    @AppStorage(Keys.countdownLength(.timed)) var countdownLength : Int = 3
    
    init() {
        super.init(.timed)
    }
}

class CountingAssessment : Assessment {
    
    @Published var taps : Int = 0
    
    init() {
        super.init(.count)
    }
}

class HeartRateAssessment : Assessment {
    
    
    @AppStorage("heart_rate_unit") var heartRate : String = "BPM"
    @AppStorage(Keys.timerLength(.heartRate)) var duration : Int = 10
    @AppStorage(Keys.countdownLength(.heartRate)) var countdownLength : Int = 3
    @Published var taps : Int = 0
    
    @Published var countingState : Set<CountingState> = [.ready]
    
    init() {
        super.init(.heartRate)
    }
}


extension AssessmentOptions {
    struct HeartRate : View {
        @EnvironmentObject var model : HeartRateAssessment
        
        var body : some View {
            
            Section("Duration") {
                BuildingBlocks.DurationPicker(duration: $model.duration)
                BuildingBlocks.CountdownStepper(countdown: $model.countdownLength)
            }
            
            Section {
                Toggle("Show Decimal on Timer", isOn: .constant(true))
            }
            
            Section {
                Picker("Display Unit", selection: $model.heartRate) {
                    ForEach(HeartRateDisplayUnit.allCases) {
                        Text($0.rawValue).tag($0)
                    }
                }
            }
        }
    }
}

extension AssessmentOptions {
    
    struct BuildingBlocks {
        
        struct DurationPicker : View {
            @Binding var duration : Int
            private let range : ClosedRange<Int> = 1...60
            
            var body: some View {
                Picker("Set the Seconds", selection: $duration) {
                    ForEach(range, id: \.self) {
                        Text("\($0)").tag($0)
                    }
                }.pickerStyle(.wheel)
            }
        }
        
        struct CountdownStepper : View {
            
            @Binding var countdown : Int
            
            var body: some View {
                Stepper("Countdown for \(countdown) \(countdown == 1 ? "sec" : "secs")", value: $countdown, in: 0...60)
            }
        }
    }
    
}

