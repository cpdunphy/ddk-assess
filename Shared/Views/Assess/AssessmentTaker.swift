//
//  AssessmentTaker.swift
//  AssessmentTaker
//
//  Created by Collin Dunphy on 7/18/21.
//

import SwiftUI

struct AssessmentTaker: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State var assessmentSettingsSelection : AssessmentType? = nil
    
    var type : AssessmentType
    
    @ViewBuilder
    var statsDisplay : some View {
        switch type {
        case .timed:
            EmptyView()
        case .count:
            EmptyView()
        case .heartRate:
            Stats.HeartRate()
        }
    }
    
    @ViewBuilder
    var controlButtons : some View {
        switch type {
        case .timed:
            EmptyView()
        case .count:
            EmptyView()
        case .heartRate:
            ControlButtons.HeartRate()
        }
    }
    
    @ViewBuilder
    var tapButtons : some View {
        switch type {
        case .timed:
            EmptyView()
        case .count:
            EmptyView()
        case .heartRate:
            TapButtons.HeartRate()
        }
    }
    
    private let spacing: CGFloat = 12
    private let cornerRadius : Int = 15
    
    // MARK: - Body
    var body: some View {
        
        GeometryReader { geo in
            
            VStack(spacing: 0) {
                
                // Actual Assessment taking, customized to fit the given type
                VStack(spacing: spacing) {
                    
                    VStack(spacing: spacing) {
                        statsDisplay
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        
                        HStack(spacing: spacing) {
                            controlButtons
                        }
                    }.layoutPriority(2)
                    
                    tapButtons
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .layoutPriority(2)
                    
                }
                .scenePadding(.horizontal)
                .scenePadding(geo.safeAreaInsets.bottom != 0 ? .top : .vertical)
                .layoutPriority(1)
                
                
                // Required to keep the navigationBar pressed against the top of the view when now buttons or stats are available to display
                Spacer(minLength: 0)
                    .layoutPriority(0)
                
            }
        }
        
        // Navigation Bar
        .safeAreaInset(edge: .top, spacing: 0) {
            navigationBar
                .background(.bar)
        }
        
        .background(Color(.systemGroupedBackground))
        .sheet(item: $assessmentSettingsSelection) { type in
            NavigationView {
                AssessmentOptions(type: type)
            }
        }
    }
}

struct AssessmentTaker_Previews: PreviewProvider {
    static var previews: some View {
        AssessmentTaker(type: .timed)
    }
}

// MARK: - Navigation Bar
extension AssessmentTaker {
    var navigationBar : some View {
        VStack(spacing: 0) {
            
            HStack {
                
                AssessmentGalleryIcon(type: type)
                
                VStack(alignment: .leading) {
                    
                    Text(type.title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .lineLimit(1)
                    
                    Text("53 assessments")
                        .foregroundColor(.secondary)
                        .font(.caption)
                        .lineLimit(1)
                }
                
                Spacer()
                
                HStack(spacing: 16) {
                    
                    Button {
                        assessmentSettingsSelection = type
                    } label: {
                        Label("Options", systemImage: "ellipsis.circle")
                    }
                    
                    Button {
                        dismiss()
                    } label: {
                        Label("Close", systemImage: "xmark.circle.fill")
                            .symbolRenderingMode(.hierarchical)
                            .foregroundColor(.gray)
                    }
                }
                .labelStyle(.iconOnly)
                .imageScale(.large)
                .font(.title3)
                
            }.padding()
            
            Divider()
                .background(.ultraThickMaterial)
        }
        
    }
}

// MARK: Building Blocks
extension AssessmentTaker {
    
    struct BuildingBlocks {
        
        struct ControlButton : View {
            var title: String
            var systemImage: String
            var color: Color
            
            var action : () -> Void
            
            var body: some View {
                Button(action: action) {
                    Label(title, systemImage: systemImage)
                        .lineLimit(2)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .tint(color)
                .font(.title2)
            }
        }
        
        
        struct TitleFont: ViewModifier {
            @ScaledMetric(relativeTo: .largeTitle) var titleFontSize: CGFloat = 48
            
            func body(content: Content) -> some View {
                return content.font(.system(size: titleFontSize, weight: .bold, design: .rounded).monospacedDigit())
            }
        }
        
        struct SubtitleFont: ViewModifier {
            @ScaledMetric(relativeTo: .largeTitle) var subtitleFontSize: CGFloat = 24
            
            func body(content: Content) -> some View {
                return content
                    .font(Font.system(size: subtitleFontSize, weight: .regular, design: .rounded).monospacedDigit())
            }
        }
        
        struct Separator : View {
            
            var width : CGFloat = 95
            
            var body: some View {
                RoundedRectangle(cornerRadius: 100.0)
                    .foregroundColor(.secondary)
                    .frame(width: width, height: 4)
                    .padding(.vertical, 10)
            }
        }
    }
}

//@available(iOS 13, macCatalyst 13, tvOS 13, watchOS 6, *)
//extension View {
//    func scaledFont(name: String, size: CGFloat) -> some View {
//        return self.modifier(ScaledFont(name: name, size: size))
//    }
//}


// MARK: Customized portions
extension AssessmentTaker {
    
    // MARK: Stats
    struct Stats {
        
        
        
        // Format Time(s) to m/s/ds
        static func getStandardTimeDisplayString(_ time: Double, showDecimal: Bool) -> String {
            //https://stackoverflow.com/questions/35215694/format-timer-label-to-hoursminutesseconds-in-swift/35215847
            //https://stackoverflow.com/questions/52332747/what-are-the-supported-swift-string-format-specifiers/52332748
            
            let minutes = Int(time) / 60 % 60
            let seconds = Int(time) % 60
            let deciseconds = time - Double(Int(time))
            var decisecondsFullStr = "\(Double(round(10*deciseconds)/10))"
            decisecondsFullStr.remove(at: decisecondsFullStr.startIndex)
            if !showDecimal {
                return String(format:"%02i:%02i", minutes, seconds)
            } else {
                return String(format:"%02i:%02i%3$@", minutes, seconds, decisecondsFullStr)
            }
        }
        
        
        struct HeartRate : View {
            
            @EnvironmentObject var ddk : DDKModel
            @EnvironmentObject var model : HeartRateAssessment
            @EnvironmentObject var timerSession : TimerSession
            
            var body: some View {
                GeometryReader { geo in
                    VStack(spacing: 0) {
                        
                        Text(timerDescription)
                            .modifier(BuildingBlocks.TitleFont())
                        
                        BuildingBlocks.Separator()
                        
                        Text(tapDescrition(model.taps))
                            .modifier(BuildingBlocks.SubtitleFont())
                        
                    }.position(x: geo.size.width / 2, y: geo.size.height / 2)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.secondarySystemGroupedBackground))
                .cornerRadius(15.0)
                .onChange(of: timerSession.currentDateTime, perform: checkStatus)
                
            }
            
            func tapDescrition(_ taps: Int) -> String {
                return "\(taps) \(taps == 1 ? "Tap" : "Taps")"
            }
            
            var timerDescription : String {
                switch model.countingState {
                case [.countdown], [.countdown, .paused]:
                    return "\(Int(min((calculateTimeLeft() ?? 0).rounded(.up), Double(model.countdownLength))))..."
                case [.counting], [.counting, .paused]:
                    return getStandardTimeDisplayString(calculateTimeLeft() ?? 0, showDecimal: model.showDecimalOnTimer)
                default:
                    return getStandardTimeDisplayString(Double(model.duration), showDecimal: model.showDecimalOnTimer)
                }
            }
            
            // Check Status. TODO: Since this is tied to the view, it doesn't transition to the next state if the view is closed.
            func checkStatus(_ newValue: Date) {
                let state = model.countingState
                
                guard let timeLeft = calculateTimeLeft() else {
                    return
                }
                
                if timeLeft <= 0 {
                    if state.contains(.countdown) {
                        model.transitionToCounting()
                    } else if state.contains(.counting) {
                        model.transitionToFinished()
                        //TODO: Send finished model to DDKModel
                        let record = AssessmentRecord(
                            date: .now,
                            taps: model.taps,
                            type: .heartRate,
                            duration: Double(model.duration)
                        )
                        ddk.addRecord(record)
                    }
                }
            }
            
            
            func calculateTimeLeft() -> Double? {
                
                let state = model.countingState
                
                var start = model.startOfAssessment
                let timeSpentPaused = model.timeSpentPaused
                
                start.addTimeInterval(timeSpentPaused)
                
                switch state {
                case [.paused, .countdown]:
                    return start
                        .addingTimeInterval(TimeInterval(model.countdownLength))
                        .timeIntervalSince(model.timeOfLatestPause)
                case [.countdown]:
                    return start
                        .addingTimeInterval(TimeInterval(model.countdownLength))
                        .timeIntervalSince(timerSession.currentDateTime)
                case [.paused, .counting]:
                    return start
                        .addingTimeInterval(TimeInterval(model.duration))
                        .timeIntervalSince(model.timeOfLatestPause)
                case [.counting]:
                    return start
                        .addingTimeInterval(TimeInterval(model.duration))
                        .timeIntervalSince(timerSession.currentDateTime)
                default:
                    return nil
                }
            }
        }
    }
    
    // MARK: Controls
    struct ControlButtons {
        
        struct HeartRate : View {
            @EnvironmentObject var model : HeartRateAssessment
            
            var body: some View {
                leftButton
                
                rightButton
            }
            
            @ViewBuilder
            var rightButton : some View {
                switch model.countingState {
                case [CountingState.ready]:
                    ButtonOptions.start.button(action: model.startTimer)
                case [CountingState.paused, .counting], [.paused, .countdown]:
                    ButtonOptions.resume.button(action: model.resumeTimer)
                case [CountingState.counting], [.countdown]:
                    ButtonOptions.pause.button(action: model.pauseTimer)
                default:
                    ButtonOptions.reset.button(action: model.resetTimer)
                }
            }
            
            @ViewBuilder
            var leftButton : some View {
                switch model.countingState {
                case [CountingState.ready]:
                    ButtonOptions.reset.button(action: model.resetTimer)
                case [CountingState.countdown], [.counting], [.counting, .paused], [.countdown, .paused]:
                    ButtonOptions.stop.button(action: model.resetTimer)
                default:
                    ButtonOptions.reset.button(action: model.resetTimer)
                }
            }
        }
        
    }
    
    // MARK: Taps
    struct TapButtons {
        struct HeartRate : View {
            
            @EnvironmentObject var model : HeartRateAssessment
            
            var body: some View {
                TapButton(
                    taps: $model.taps,
                    countingState: model.countingState
                )
            }
        }
    }
}
