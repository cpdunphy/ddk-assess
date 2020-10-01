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
    var buttons: some View {
        HStack {
            Spacer(minLength: 0)
            Button(action: {
                if model.assessType == .timed {

                } else {
                    model.resetCount()
                }
            }) {
                Label("Reset", systemImage: "gobackward")
                    .font(.title2)
                    .foregroundColor(.red)
                    .padding(4)
                    .background(Color(.tertiarySystemGroupedBackground))
                    .cornerRadius(10.0)
            }
            Spacer(minLength: 0)
            Spacer(minLength: 0)
            Button(action: {
                if model.assessType == .timed {

                } else {
                    model.logCount()
                }
            }) {
                Label("Log", systemImage: "square.and.pencil")
                    .font(.title2)
                    .foregroundColor(.green)
                    .padding(4)
                    .background(Color(.tertiarySystemGroupedBackground))
                    .cornerRadius(10.0)
            }
            Spacer(minLength: 0)
        }
    }
    
    @ViewBuilder var assessSwitch : some View {
        switch model.assessType {
        case .timed:
            timed
        case .count:
            count
        }
    }
    
    @ViewBuilder var timed : some View {
        switch model.currentTimedState {
        case .ready:
            timePicker
        case .counting:
            timePicker
        default:
            Text("Default")
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
    
    
    
    var count : some View {
        VStack {
            Text(model.currentCountState == .ready ? "0:00.0" : timerDescription)
                .font(.largeTitle)
                .fontWeight(.bold)
                .kerning(1)
            
            Text(tapDescrition)
        }
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
    
}

struct StatsDisplay_Previews: PreviewProvider {
    static var previews: some View {
        StatsDisplay()
    }
}

