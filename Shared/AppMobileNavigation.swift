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
        VStack {
            Text(TimerLabel())
                .font(.largeTitle)
                .fontWeight(.bold)
                .kerning(1)
                .frame(alignment: .leading)
            
            Button("Connect") {
//                self.timer = Timer.publish(every: 0.1, on: .main, in: .common)
//                    .autoconnect()
//                    .sink(receiveValue: { (time) in
//                        date = time
//                    })
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
            TapButton()
        }
        .padding(.horizontal, 20)
    }
    
    func TimerLabel() -> String {
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



// Format Time(s) to h/m/s/ds
func getStandardTimeDisplayString(_ time: Double) -> String {
    
    //https://stackoverflow.com/questions/35215694/format-timer-label-to-hoursminutesseconds-in-swift/35215847
    let mins = Int(time)/60
    let remainingSeconds = time - Double((mins * 60))
    let seconds2 = String(format: "%.1f", remainingSeconds)
    print("\(seconds2)")
//    var minsZero = ""
//    while "\(mins)".count + minsZero.count < 2 {
//        minsZero += "0"
//    }
//    var secsZero = ""
//    while seconds.count + secsZero.count < 4 {
//        secsZero += "0"
//    }
//
//    return "\(minsZero)\(mins):\(secsZero)\(seconds)"
    let minutes = Int(time) / 60 % 60
    let seconds = Int(time) % 60
    let deciseconds = time - Double(Int(time))
    var decisecondsFullStr = "\(Double(round(10*deciseconds)/10))"
    decisecondsFullStr.remove(at: decisecondsFullStr.startIndex)
    print("\(seconds):\(deciseconds)")
    return String(format:"%02i:%02i%3$@", minutes, seconds, decisecondsFullStr)
    
    
}
