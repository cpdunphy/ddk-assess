//
//  AppMobileNavigation.swift
//  Diadochokinetic Assess
//
//  Created by Collin Dunphy on 9/24/20.
//

import SwiftUI
import Combine

struct AppMobileNavigation: View {

    
    @EnvironmentObject var model : DDKModel
    
    
    var body: some View {
        AssessScreen()
            .toolbar {
                ToolbarItem(placement: ToolbarItemPlacement.bottomBar) {
                    AssessmentPicker(type: $model.assessType)
                }
            }

    }

}

struct AppMobileNavigation_Previews: PreviewProvider {
    static var previews: some View {
        AppMobileNavigation()
    }
}

struct AssessScreen : View {
    @EnvironmentObject var model : DDKModel
    @EnvironmentObject var timerSession : TimerSession
    @State private var date = Date()
    @State private var timer : AnyCancellable?

    var body : some View {
        VStack(spacing: 12) {
            VStack {
                Text(timerDescription)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .kerning(1)
                
                Text(tapDescrition)
            }
            .frame(minWidth: 200, maxWidth: .infinity, minHeight: 200, maxHeight: .infinity)
            .background(Color(.secondarySystemFill))
            .layoutPriority(1)
            
            HStack {
                Button("Connect") {
    //                clearCurrentTime()
    //                model.connectTimer()
                }
                
                Button("Clear") {
                    clearCurrentTime()
                }
                
                Button("Disconnect") {
    //                timer?.cancel()
    //                model.disconnectTimer()
                }
            }
            .background(Color.green)
            .layoutPriority(0)
            
            TapButton()
                .layoutPriority(1)

        }
        .padding(.horizontal, 20)
        .padding(.bottom, 70)

    }
    
    var tapDescrition : String {
        return "\(model.currentTaps) \(model.currentTaps == 1 ? "Tap" : "Taps")"
    }
    
    
    var timerDescription : String {
        switch model.assessType {
        case .timed:
            return getStandardTimeDisplayString(abs(model.referenceDate.timeIntervalSince(timerSession.currentDateTime)))
        case .count:
            return getStandardTimeDisplayString(max(0, timerSession.currentDateTime.timeIntervalSince(model.referenceDate)))
        }
    }
    
    func clearCurrentTime() {
        switch model.assessType {
        case .timed:
            model.latestTimedDateRef = Date()
        case .count:
            model.latestCountDateRef = Date()
        }
    }
    
}



// Format Time(s) to m/s/ds
func getStandardTimeDisplayString(_ time: Double) -> String {
    //https://stackoverflow.com/questions/35215694/format-timer-label-to-hoursminutesseconds-in-swift/35215847
    //https://stackoverflow.com/questions/52332747/what-are-the-supported-swift-string-format-specifiers/52332748
    
    let minutes = Int(time) / 60 % 60
    let seconds = Int(time) % 60
    let deciseconds = time - Double(Int(time))
    var decisecondsFullStr = "\(Double(round(10*deciseconds)/10))"
    decisecondsFullStr.remove(at: decisecondsFullStr.startIndex)
    return String(format:"%02i:%02i%3$@", minutes, seconds, decisecondsFullStr)
}
