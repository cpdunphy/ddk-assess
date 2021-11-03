//
//  StatsDisplay.swift
//  Diadochokinetic Assess
//
//  Created by Collin Dunphy on 9/27/20.
//

import SwiftUI

@available(*, deprecated, message: "In favor of a scalable architecture.")
struct StatsDisplay: View {
    
    @EnvironmentObject var model : DDKModel
    @EnvironmentObject var timerSession : TimerSession
    
    var body: some View {
        ZStack(alignment: .center) {
            EmptyView()
        }
        .frame(minWidth: 200, maxWidth: .infinity, minHeight: 200, maxHeight: .infinity)
        .background(Color(.secondarySystemGroupedBackground)) //TODO: Add Mac compatability
    }
    
    // MARK: - Buttons
    
    var buttons: some View {
        HStack {
            Spacer(minLength: 0)
                      
            leftButtonOptionLogic().button(action: handleLeft)
            
            Spacer(minLength: 0)
            Spacer(minLength: 0)
                        
            rightButtonOptionLogic().button(action: handleRight)
            
            Spacer(minLength: 0)
        }
    }
    
    func handleLeft() {
        switch model.assessType {
        case .timed:
            handleLeftTimed()
        case .count:
            model.resetCount()
        }
    }
    
    func handleRight() {
        switch model.assessType {
        case .timed:
            handleRightTimed()
        case .count:
            model.logCount()
        }
    }
    
    func handleLeftTimed() {
        model.resetTimed()
    }
    
    func handleRightTimed() {
        switch model.currentTimedState {
        case [CountingState.ready]:
            model.startTimed()
        case [CountingState.paused, .counting], [.paused, .countdown]:
            model.resumeTimed()
        case [CountingState.counting], [.countdown]:
            model.pauseTimed()
//        case [CountingState.finished]:
//            showBPMStatus.toggle()
        default:
            print("Default Handling Right Button")
        }
    }
    
    @ViewBuilder var leftButton : some View {
        if model.assessType == .timed {
            timedLeftButton
        } else {
            Label(AssessmentTaker.ButtonOptions.reset.title, systemImage: AssessmentTaker.ButtonOptions.reset.systemSymbol)
        }
    }
    
    @ViewBuilder var rightButton : some View {
        if model.assessType == .timed {
            timedRightButton
        } else {
            Label(AssessmentTaker.ButtonOptions.log.title, systemImage: AssessmentTaker.ButtonOptions.log.systemSymbol)
        }
    }
    
    @AppStorage("showBPMStatus") var showBPMStatus : Bool = false
    
    func rightButtonOptionLogic() -> AssessmentTaker.ButtonOptions {
        if model.assessType == .timed {
            switch model.currentTimedState {
            case [CountingState.ready]:
                return .start
            case [CountingState.paused, .counting], [.paused, .countdown]:
                return .resume
            case [CountingState.counting], [.countdown]:
                return .pause
//            case [CountingState.finished]:
//                if showBPMStatus {
////                    return .heartEnabled
//                } else {
////                    return .heartDisabled
//                }
            default:
                return .reset
            }
        } else {
            return .log
        }
    }
    
    func leftButtonOptionLogic() -> AssessmentTaker.ButtonOptions {
        if model.assessType == .timed {
            switch model.currentTimedState {
            case [CountingState.ready]://, [.finished]:
                return .reset
            case [CountingState.countdown], [.counting], [.counting, .paused], [.countdown, .paused]:
                return .stop
            default:
                return .reset
            }
        } else {
            return .reset
        }
    }
    
    @ViewBuilder var timedRightButton : some View {
        let style: AssessmentTaker.ButtonOptions = rightButtonOptionLogic()
        Label(style.title, systemImage: style.systemSymbol)
    }
    
    @ViewBuilder var timedLeftButton : some View {
        let style : AssessmentTaker.ButtonOptions = leftButtonOptionLogic()
        Label(style.title, systemImage: style.systemSymbol)
    }
    
    // MARK: - Timed
    
    @ViewBuilder var timedDisplay : some View {
        switch model.currentTimedState {
        case [.ready]:
            timePicker
        case [.countdown], [.counting], [.paused, .counting], [.paused, .countdown]:
            timerIsCounting
//        case [.finished]:
//            timerIsFinished
        default:
            Text("Default Timed Display")
        }
    }
    
    var timePicker : some View {
        VStack(spacing: 0) {
            #if os(iOS)
            Text("Set the Seconds")
            #endif
            Picker("Set the Seconds", selection: $model.currentlySelectedTimerLength) {
                ForEach(1...60, id: \.self) {
                    Text("\($0)").tag($0)
                }
            }.pickerStyle(.wheel)
        }
    }
    
    var timerIsCounting : some View {
        ZStack {
            progressIndicator
            VStack(spacing: 0) {
                titleLabel(timerDescription)
                
                separator
                
                subtitleLabel(tapDescrition)
            }
        }
    }
    
    
    var progressIndicator : some View {
        var percent = 1.0
        if model.currentTimedState != [.countdown] && model.currentTimedState != [.countdown, .paused] {
//            withAnimation {
                percent = calculateTimeLeft()/Double(model.currentlySelectedTimerLength)
//            }
        }
        
        return ZStack {
            RoundedRectangle(cornerRadius: 15.0)
                .stroke(Color("RectangleBackgroundProgrss"), lineWidth: 7)
            
            RoundedRectProgress()
                .trim(from: 0, to: CGFloat(percent))
                .stroke(AngularGradient(gradient: Gradient(colors: Color.progressGradientColors), center: .center, startAngle: .degrees(-90), endAngle: .degrees(270)), style: StrokeStyle(lineWidth: 7,  lineCap: .round))
            
            ///TODO: Try to use strokeBorder() so that it does the border inside of the shape.. not currently possible because .trim returns 'Shape' which doesnt conform to 'ShapeInsettable'
            
            if model.currentTimedState != [.ready] {
                RoundedRectProgress()
                    .trim(from: 0.0, to: 0.001)
                    .stroke(Color.progressGradientColors[0], style: StrokeStyle(lineWidth: 7, lineCap: .round))
            }
        }.padding(4)
        
    }
    
    var timerIsFinished : some View {
        titleLabel(showBPMStatus ? bpmDescriptionStr : tapsDescriptionStr)
    }
    
    func calculateBPM(taps: Int, duration: TimeInterval) -> Int {
        let numToComplete = 60/duration
        let bpm = Double(taps) * numToComplete
        return Int(bpm)
    }
    
    var bpmDescriptionStr : String {
        let bpm = calculateBPM(taps: model.currentTimedTaps, duration: TimeInterval(model.currentlySelectedTimerLength))
        return "\(bpm) bpm"
    }
    
    var tapsDescriptionStr : String {
        return "\(model.currentTimedTaps) \(model.currentTimedTaps == 1 ? "tap" : "taps")"
    }
    
    // MARK: - Count
    var countDisplay : some View {
        VStack(spacing: 0) {
            titleLabel(tapDescrition)
            
            separator
            
            subtitleLabel(timerDescription)
        }
    }
    
    // MARK: - Supporting views
    
    func titleLabel(_ label: String) -> some View {
        Text(label)
            .font(Font.system(size: titleFontSize, weight: .bold, design: .rounded).monospacedDigit())
    }
    
    @ScaledMetric(relativeTo: .largeTitle) var titleFontSize: CGFloat = 48
    @ScaledMetric(relativeTo: .headline) var subtitleFontSize: CGFloat = 24
    
    var separator : some View {
        RoundedRectangle(cornerRadius: 100.0)
            .foregroundColor(.secondary)
            .frame(width: 100, height: 5)
            .padding(.vertical, 8)
    }
    
    func subtitleLabel(_ label: String) -> some View {
        Text(label)
            .font(Font.system(size: subtitleFontSize, weight: .regular, design: .rounded).monospacedDigit())
            .kerning(1)
    }
    
    
    var tapDescrition : String {
        return "\(model.currentTaps) \(model.currentTaps == 1 ? "Tap" : "Taps")"
    }
    
    func calculateTimeLeft() -> Double {
        var duration : Double = 0.0
        let totalTime = TimeInterval(model.currentlySelectedTimerLength)
        
        if model.currentTimedState == [.paused, .counting] {
            duration = model.latestTimedDateRef
                .addingTimeInterval(totalTime)
                .addingTimeInterval(model.timeSpentPaused)
                .timeIntervalSince(model.timeStartLatestPaused)
        } else {
            duration = model.latestTimedDateRef
                .addingTimeInterval(totalTime)
                .addingTimeInterval(model.timeSpentPaused)
                .timeIntervalSince(timerSession.currentDateTime)
        }
        
        if duration <= 0 {
            model.finishTimer()
        }
        
        return duration
    }
    
    func calculateTimeLeftCountdown() -> Double {
        var duration : Double = 0.0
        let totalTime = TimeInterval(model.currentlySelectedCountdownLength)
        if model.currentTimedState == [.paused, .countdown] {
            duration = model.latestTimedDateRef
                .addingTimeInterval(totalTime)
                .addingTimeInterval(model.timeSpentPaused)
                .timeIntervalSince(model.timeStartLatestPaused)
        } else {
            duration = model.latestTimedDateRef
                .addingTimeInterval(totalTime)
                .addingTimeInterval(model.timeSpentPaused)
                .timeIntervalSince(timerSession.currentDateTime)
        }
        
        if duration <= 0 {
            model.finishCountdown()
        }
        
        return duration
    }
    
    var timerDescription : String {
        if model.currentTimedState.contains(.countdown) {
            let _ = calculateTimeLeftCountdown()
        } else if model.currentTimedState.contains(.counting) {
            let _ = calculateTimeLeft()
        }
        
        switch model.assessType {
        case .timed:
            switch model.currentTimedState {
            case [.countdown], [.countdown, .paused]:
                return "\(Int(min(calculateTimeLeftCountdown().rounded(.up), Double(model.currentlySelectedCountdownLength))))..."
            case [.counting], [.counting, .paused]:
                return getStandardTimeDisplayString(calculateTimeLeft())
            default:
                return "Default Timer Description"
            }
        case .count:
            if model.currentCountState == .ready {
                return showDecimalTimer ? "00:00.0" : "00:00"
            }
            
            return getStandardTimeDisplayString(max(0, timerSession.currentDateTime.timeIntervalSince(model.latestCountDateRef)))
        }
    }
    
    @AppStorage("show_decimal_timer") var showDecimalTimer : Bool = true
    
    
    // Format Time(s) to m/s/ds
    func getStandardTimeDisplayString(_ time: Double) -> String {
        //https://stackoverflow.com/questions/35215694/format-timer-label-to-hoursminutesseconds-in-swift/35215847
        //https://stackoverflow.com/questions/52332747/what-are-the-supported-swift-string-format-specifiers/52332748
        
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        let deciseconds = time - Double(Int(time))
        var decisecondsFullStr = "\(Double(round(10*deciseconds)/10))"
        decisecondsFullStr.remove(at: decisecondsFullStr.startIndex)
        if !showDecimalTimer {
            return String(format:"%02i:%02i", minutes, seconds)
        } else {
            return String(format:"%02i:%02i%3$@", minutes, seconds, decisecondsFullStr)
        }
    }
}

struct StatsDisplay_Previews: PreviewProvider {
    static var previews: some View {
        StatsDisplay()
    }
}




