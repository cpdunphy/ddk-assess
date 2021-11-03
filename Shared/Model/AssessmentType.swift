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
    
    static func showDecimal(_ type: AssessmentType) -> String {
        return type.rawValue + "_show_decimal"
    }
}



class TimedCountingAssessment : Assessment, TimedAssessmentProtocol {

    @Published var taps : Int = 0
    @AppStorage(Keys.timerLength(.timed)) var duration : Int = 10
    @AppStorage(Keys.countdownLength(.timed)) var countdownLength : Int = 3
    @Published var startOfAssessment : Date = Date.now

    @Published var countingState: Set<CountingState> = [.ready]
    
    init() {
        super.init(.timed)
    }
    
    func startTimer() {
        countingState = [.countdown]
        startOfAssessment = Date.now
    }
    
    func pauseTimer() {
        
    }
    
    func resumeTimer() {
        
    }
    
    func resetTimer() {
        
    }
    
    func transitionToCounting() {
        
    }
    
    func transitionToFinished() {
        
    }
}

class CountingAssessment : Assessment {
    
    @Published var taps : Int = 0
    
    init() {
        super.init(.count)
    }
}

struct Defaults {
    public static let hrDisplayUnit : HeartRateDisplayUnit = .bpm
    
    public static let countdownDuration : Int = 3
    public static let timerDuration : Int = 10
    
    public static let timerRange : ClosedRange<Int> = 1...60
    public static let countdownRange : ClosedRange<Int> = 0...30
}

//class TimedAssessmentBase : Assessment {
////    var duration: Int = 0
//
////    var countdownLength: Int
//
//    @Published var countingState: Set<CountingState> = [.ready]
//
//    func startTimer() {
//        countingState = [.countdown]
//        startOfAssessment = Date.now
//    }
//
//    init() {
//
//    }
//}
protocol TimedAssessmentProtocol {
    var duration : Int { get set }
    var countdownLength : Int { get set }
    var countingState : Set<CountingState> { get set }
    
    func startTimer()
    func pauseTimer()
    func resumeTimer()
    func resetTimer()
    func transitionToCounting()
    func transitionToFinished()
}

class TimedAssessment : Assessment {
    
    override init(_ type: AssessmentType) {
        super.init(type)
    }
}

class HeartRateAssessment : TimedAssessment, TimedAssessmentProtocol {
    
    @AppStorage("heart_rate_unit") var heartRate : HeartRateDisplayUnit = Defaults.hrDisplayUnit
    @AppStorage(Keys.timerLength(.heartRate)) var duration : Int = Defaults.timerDuration
    @AppStorage(Keys.countdownLength(.heartRate)) var countdownLength : Int = Defaults.countdownDuration
    @AppStorage(Keys.showDecimal(.heartRate)) var showDecimalOnTimer : Bool = true
    
    @Published var startOfAssessment : Date = Date.now
    @Published var taps : Int = 0
    
    @Published var countingState : Set<CountingState> = [.ready]
    
    /// Time spent paused on timed mode
    @Published var timeSpentPaused : Double = 0.0
    
    /// Lastest time a timed assessment was started
    @Published var timeOfLatestPause : Date = Date()
    

    init() {
        super.init(.heartRate)
    }
    
    func startTimer() {
        resetTimer()
        countingState = [.countdown]
        startOfAssessment = Date.now
    }
    
    func pauseTimer() {
        countingState.insert(.paused)
        timeOfLatestPause = Date.now
    }
    
    func resumeTimer() {
        countingState.remove(.paused)
        let duration = Date.now.timeIntervalSince(timeOfLatestPause)
        timeOfLatestPause += duration
    }
    
    func resetTimer() {
        countingState = [.ready]
        taps = 0
    }
    
    func transitionToCounting() {
        countingState = [.counting]
        timeSpentPaused = 0
        startOfAssessment = .now
    }
    
    func transitionToFinished() {
        if countingState != [.ready] {
            countingState = [.ready]

        }
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
                Toggle("Show Decimal on Timer", isOn: $model.showDecimalOnTimer)
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
            var range : ClosedRange<Int>
            
            init (duration: Binding<Int>, range: ClosedRange<Int> = Defaults.timerRange) {
                self._duration = duration
                self.range = range
                if !range.contains(self.duration) {
                    self.duration = Defaults.timerDuration
                }
            }
            
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
            var range: ClosedRange<Int>
            
            init (countdown: Binding<Int>, range: ClosedRange<Int> = Defaults.countdownRange) {
                self._countdown = countdown
                self.range = range
                if !range.contains(self.countdown) {
                    self.countdown = Defaults.countdownDuration
                }
            }
            var body: some View {
                Stepper("Countdown for \(countdown) \(countdown == 1 ? "sec" : "secs")", value: $countdown, in: range)
            }
        }
    }
    
}

