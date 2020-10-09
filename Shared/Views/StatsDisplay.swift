//
//  StatsDisplay.swift
//  Diadochokinetic Assess
//
//  Created by Collin Dunphy on 9/27/20.
//

import SwiftUI

struct StatsDisplay: View {
    
    @EnvironmentObject var model : DDKModel
    @EnvironmentObject var timerSession : TimerSession
    
    var body: some View {
        ZStack(alignment: .center) {
            assessSwitch
            VStack {
                Spacer(minLength: 0)
                buttons
                    .padding(.bottom)
            }
        }
        .frame(minWidth: 200, maxWidth: .infinity, minHeight: 200, maxHeight: .infinity)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(15.0)
    }
    
    @ViewBuilder var assessSwitch : some View {
        switch model.assessType {
        case .timed:
            timedDisplay
        case .count:
            countDisplay
        }
    }
    
    // MARK: - Buttons

    var buttons: some View {
        HStack {
            Spacer(minLength: 0)
            Button(action: handleLeft) {
                leftButton
            }
            Spacer(minLength: 0)
            Spacer(minLength: 0)
            Button(action: handleRight) {
                rightButton
            }
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
        case [CountingState.finished]:
            showBPMStatus.toggle()
        default:
            print("Default Handling Right Button")
        }
    }
    
    @ViewBuilder var leftButton : some View {
        if model.assessType == .timed {
            timedLeftButton
        } else {
            ControlButton(.reset)
        }
    }
    
    @ViewBuilder var rightButton : some View {
        if model.assessType == .timed {
            timedRightButton
        } else {
            ControlButton(.log)
        }
    }
    
    @AppStorage("showBPMStatus") var showBPMStatus : Bool = false
    
    @ViewBuilder var timedRightButton : some View {
        switch model.currentTimedState {
        case [CountingState.ready]:
            ControlButton(.start)
        case [CountingState.paused, .counting], [.paused, .countdown]:
            ControlButton(.resume)
        case [CountingState.counting], [.countdown]:
            ControlButton(.pause)
        case [CountingState.finished]:
            if showBPMStatus {
                ControlButton(.heartEnabled)
            } else {
                ControlButton(.heartDisabled)
            }
        default:
            Text("Default Right Button")
        }
    }
    
    @ViewBuilder var timedLeftButton : some View {
        switch model.currentTimedState {
        case [CountingState.ready], [.finished]:
            ControlButton(.reset)
        case [CountingState.countdown], [.counting], [.counting, .paused], [.countdown, .paused]:
            ControlButton(.stop)
        default:
            Text("Default Left Button")
        }
    }
    
    func ControlButton(_ option: ButtonOptions) -> some View {
        return Label(option.title, systemImage: option.systemSymbol)
            .foregroundColor(option.color)
            .font(.title2)
            .padding(6)
            .background(option.backgroundColor)
            .cornerRadius(10.0)
    }
    
    // MARK: - Timed
    
    @ViewBuilder var timedDisplay : some View {
        switch model.currentTimedState {
        case [.ready]:
            timePicker
        case [.countdown], [.counting], [.paused, .counting], [.paused, .countdown]:
            timerIsCounting
        case [.finished]:
            timerIsFinished
        default:
            Text("Default Timed Display")
        }
    }

    var timePicker : some View {
        VStack(spacing: 0) {
            Text("Set the Seconds")
            Picker("Set the Seconds", selection: $model.currentlySelectedTimerLength) {
                ForEach(1...60, id: \.self) {
                    Text("\($0)")
                        .tag($0)
                }
            }
        }
    }
        
    var timerIsCounting : some View {
        ZStack {
            progressIndicator
            VStack(spacing: 0) {
                titleLabel(timerDescription)

                seperator

                subtitleLabel(tapDescrition)
            }
        }
    }
    
    let gColors = [Color(#colorLiteral(red: 0.214261921, green: 0.3599105657, blue: 0.5557389428, alpha: 1)), Color(#colorLiteral(red: 0.2784313725, green: 0.8274509804, blue: 0.7764705882, alpha: 1))]

    var progressIndicator : some View {
        var percent = 1.0
        if model.currentTimedState != [.countdown] && model.currentTimedState != [.countdown, .paused] {
        percent = calculateTimeLeft()/Double(model.currentlySelectedTimerLength)
        }
        
        return ZStack {
            RoundedRectangle(cornerRadius: 15.0)
                .stroke(Color.secondary, lineWidth: 7)
            RoundedRectProgress()
                .trim(from: 0, to: CGFloat(percent))
                .stroke(AngularGradient(gradient: Gradient(colors: gColors), center: .center, startAngle: .degrees(-90), endAngle: .degrees(270)), style: StrokeStyle(lineWidth: 7,  lineCap: .round))

            if model.currentTimedState != [.finished] {
            RoundedRectProgress()
                .trim(from: 0.0, to: 0.001)
                .stroke(gColors[0], style: StrokeStyle(lineWidth: 7, lineCap: .round))
            }
        }.padding(4).animation(.linear)
        
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
            
            seperator

            subtitleLabel(model.currentCountState == .ready ? showDecimalTimer ? "00:00.0" : "00:00" : timerDescription)
        }
    }
    
    // MARK: - Supporting views
    
    func titleLabel(_ label: String) -> some View {
            Text(label)
                .font(Font.system(size: 48, weight: .bold, design: .rounded).monospacedDigit())
        }
    
    var seperator : some View {
        RoundedRectangle(cornerRadius: 100.0)
            .foregroundColor(.secondary)
            .frame(width: 100, height: 5)
            .padding(.vertical, 8)
    }
    
    func subtitleLabel(_ label: String) -> some View {
        Text(label)
            .font(Font.system(size: 24, weight: .regular, design: .rounded).monospacedDigit())
            .kerning(1)
    }


    var tapDescrition : String {
        return "\(model.currentTaps) \(model.currentTaps == 1 ? "Tap" : "Taps")"
    }
    
    func calculateTimeLeft() -> Double {
        var duration : Double = 0.0
        let totalTime = TimeInterval(model.currentlySelectedTimerLength)
        
        if model.currentTimedState == [.paused, .counting] {
            duration = model.referenceDate
                    .addingTimeInterval(totalTime)
                    .addingTimeInterval(model.timeSpentPaused)
                    .timeIntervalSince(model.timeStartLatestPaused)
        } else {
            duration = model.referenceDate
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
            duration = model.referenceDate
                    .addingTimeInterval(totalTime)
                    .addingTimeInterval(model.timeSpentPaused)
                    .timeIntervalSince(model.timeStartLatestPaused)
        } else {
            duration = model.referenceDate
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
        switch model.assessType {
        case .timed:
            switch model.currentTimedState {
            case [.countdown], [.countdown, .paused]:
                return "\(Int(min(calculateTimeLeftCountdown().rounded(.up), Double(model.currentlySelectedCountdownLength))))..."
//                return "\(String(format: "%.1f", calculateTimeLeftCountdown()))..."
            case [.counting], [.counting, .paused]:
                return getStandardTimeDisplayString(calculateTimeLeft())
            default:
                return "Default Timer Description"
            }
        case .count:
            return getStandardTimeDisplayString(max(0, timerSession.currentDateTime.timeIntervalSince(model.referenceDate)))
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


enum ButtonOptions {
    case start
    case resume
    case pause
    case stop
    case reset
    case log
    case heartDisabled
    case heartEnabled
    
    var systemSymbol : String {
        switch self {
        case .start: return "stopwatch"
        case .resume: return "play.fill"
        case .pause: return "pause.fill"
        case .stop: return "stop.fill"
        case .reset: return "gobackward"
        case .log: return "square.and.pencil"
        case .heartDisabled: return "heart.fill"
        case .heartEnabled: return "heart.fill"
        }
    }
    
    var title : String {
        switch self {
        case .start: return "Start"
        case .resume: return "Resume"
        case .pause: return "Pause"
        case .stop: return "Stop"
        case .reset: return "Reset"
        case .log: return "Log"
        case .heartDisabled: return "Count"
        case .heartEnabled: return "BPM"
        }
    }
    
    var color : Color {
        switch self {
        case .start: return Color.green
        case .resume: return Color.green
        case .pause: return Color.orange
        case .stop: return Color.gray
        case .reset: return Color.gray
        case .log: return Color.orange
        case .heartDisabled: return Color.pink
        case .heartEnabled: return Color.white
        }
    }
    
    var backgroundColor : Color {
        switch self {
        case .heartEnabled: return Color.pink
        default: return Color(.tertiarySystemGroupedBackground)
        }
    }
}

struct RoundedRectProgress : Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        
        p.move(to: CGPoint(x: rect.midX, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.maxX - 15, y: rect.minY))
        p.addArc(center: CGPoint(x: rect.maxX - 15, y: rect.minY + 15), radius: 15.0, startAngle: .degrees(-90), endAngle: .degrees(0), clockwise: false, transform: .identity)
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - 15))
        p.addArc(center: CGPoint(x: rect.maxX - 15, y: rect.maxY - 15), radius: 15.0, startAngle: .degrees(0), endAngle: .degrees(90), clockwise: false, transform: .identity)
        p.addLine(to: CGPoint(x: rect.minX + 15, y: rect.maxY))
        p.addArc(center: CGPoint(x: rect.minX + 15, y: rect.maxY - 15), radius: 15.0, startAngle: .degrees(90), endAngle: .degrees(180), clockwise: false, transform: .identity)
        p.addLine(to: CGPoint(x: rect.minX, y: rect.minY+15))
        p.addArc(center: CGPoint(x: rect.minX + 15, y: rect.minY + 15), radius: 15.0, startAngle: .degrees(180), endAngle: .degrees(270), clockwise: false, transform: .identity)
        p.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        return p
    }
}
