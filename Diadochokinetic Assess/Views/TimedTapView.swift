//
//  TapHomeView.swift
//  Diadochokinetic Assess
//
//  Created by Collin on 12/1/19.
//  Copyright © 2019 Ballygorey Apps. All rights reserved.
//

import SwiftUI
//MARK: MAIN VIEW
struct TimedTapView : View {
    @State private var seconds = defaults.integer(forKey: secondsKey)
    @EnvironmentObject var timerSession: TimerSession
    
    let gColors = [Color(#colorLiteral(red: 0.214261921, green: 0.3599105657, blue: 0.5557389428, alpha: 1)), Color(#colorLiteral(red: 0.2784313725, green: 0.8274509804, blue: 0.7764705882, alpha: 1))]
    var body : some View {
        ZStack {
            Color("background").edgesIgnoringSafeArea(.top)
            VStack(spacing: 0) {
                ZStack {
                if timerSession.countingState == .ready {
                    ZStack(alignment: .bottom) {
                        PickerView()
                    }
                } else {
                    ZStack {
                        Circles()
                        
                        CenterCircleText().environmentObject(timerSession)
                            .frame(width: Screen.height * 0.25, height: Screen.height * 0.25)
                        
                    }
                }
                }.frame(width: Screen.width, height: Screen.height * 0.35).padding(.bottom, 0)
                HStack {
                    LeftButton()
                    Spacer()
                    RightButton()
                }.padding([.leading, .trailing], Screen.width * 0.09).offset(y: -10).padding(.bottom, 10)
                
                TapButton(timed: true).environmentObject(timerSession)
                
            }
        }
        .onDisappear(perform: {
            defaults.set(self.seconds, forKey: secondsKey)
        })
    }
    func Circles() -> some View {
        ZStack {
            Circle() ///Background circle
                .foregroundColor(Color("RectangleBackground"))
            Circle() ///Gray line behind the whole thing
                .stroke(Color(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)), lineWidth: 10)
            Circle() ///Actual percentage line
                .trim(from: 0, to: CGFloat(timerSession.percent))
                .stroke(AngularGradient(gradient: Gradient(colors: gColors), center: .center), style: StrokeStyle(lineWidth: 10,  lineCap: timerSession.countingState == .finished ? .butt : .round))
                .rotationEffect(.degrees(-90))
            Circle() ///Covers the weird bit at the top
                .trim(from: 0, to: timerSession.percent < 0.01 ? 0 : 0.005)
                .stroke(gColors[0], style: StrokeStyle(lineWidth: 10, lineCap: .round))
                .rotationEffect(.degrees(-90))
        }
    }
    
    func LeftButton() -> some View {
        Button(action: {
            self.timerSession.reset()
        }) {
            if timerSession.countingState == .ready || timerSession.countingState == .finished {
                resetButton
            } else {
                stopButton
            }
        }.disabled(timerSession.countingState == .ready)
    }
    
    func PickerView() -> some View {
        VStack(spacing: 0) {
            Text("Set the Seconds")
                .font(.custom("Nunito-SemiBold", size: 22))
                .offset(y: 27)
//                .padding(.bottom, -7)
            Picker(selection: $seconds, label: Text("")) {
                ForEach(1...60, id: \.self) { time in
                    Text("\(time)").font(.custom("Nunito-SemiBold", size: 20)).tag(time <= 60 && time > 0 ? time : 3)
                }
            }.frame(width: 290, height: 235)
                .offset(CGSize(width: -5, height: 0))
        }
//        }.frame(width: Screen.width, height: Screen.height * 0.45)
    }
    
    func RightButton() -> some View {
        Button(action: {
            ///If countingState is equal to counting make it paused, else make it equal to counting
            if self.timerSession.countingState == .ready {
                self.timerSession.startCountdown(time: self.seconds)
            } else if self.timerSession.countingState == .counting || self.timerSession.countingState == .countdown {
                self.timerSession.pause()
            } else if self.timerSession.countingState == .finished {
                self.timerSession.showHeartRate.toggle()
                defaults.set(self.timerSession.showHeartRate, forKey: heartRateKey)
            } else {
                self.timerSession.resume()
            }
        }) {
            if timerSession.countingState == .ready {
                startButton
            } else if timerSession.countingState == .counting || timerSession.countingState == .countdown {
                pauseButton
            } else if timerSession.countingState == .finished {
                ColoredButton(heartMode: true, TSLink: timerSession.showHeartRate)
            } else {
                resumeButton
            }
        }
    }
}

//MARK: TapButton
struct TapButton : View {
    @EnvironmentObject var timerSession: TimerSession
    var timed : Bool
    var body : some View {
        ZStack {
            if timerSession.countingState == .counting || !timed {
            
                Button(action: {
                    if self.timed {
                        self.timerSession.addTimedTaps()
                    } else {
                        if self.timerSession.unTimedTaps == 0 {
                            self.timerSession.firstTap()
                        }
                        self.timerSession.addUntimedTaps()
                    }
                }) {
                    getButtonImage()
                }
                
            } else {
                getButtonImage()
            }
        }
    }
    
    func getButtonImage() -> some View {
        Text(getText())
            .font(.custom("Nunito-Bold", size: 50))
            .foregroundColor(timerSession.countingState != .counting && timed ? Color(#colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)) : Color(#colorLiteral(red: 0.8640799026, green: 0.8640799026, blue: 0.8640799026, alpha: 1)))
            .frame(width: Screen.width * 0.85, height: Screen.height * 0.35)
            .background(getBackgroundColor())
            .cornerRadius(20)
            .shadow(radius: timerSession.countingState != .counting && timed ? 0 : 2)

    }
    
    func getBackgroundColor() -> Color {
        if timed {
            return timerSession.countingState == .counting && timed ? Color("tappingEnabled") : Color("tappingDisabled")
        } else {
            return Color("tappingEnabled")
        }
    }
    
    func getText() -> String {
        if timed {
            return "\(timerSession.countingState == .counting ? "Tap!" : "Disabled")"
        } else {
            return "Tap!"
        }
    }
}

//MARK: CenterCircleText
struct CenterCircleText : View {
    @EnvironmentObject var timerSession : TimerSession
    var body : some View {
        ZStack {
            if timerSession.countingState != .finished {
                Handle().offset(CGSize(width: 0, height: 22))
            }
            VStack(spacing: 10) {
                Text(getLabelText(finished: timerSession.countingState == .finished, taps: timerSession.timedTaps, countdownCount: timerSession.countdownCount, showHeartRate: timerSession.showHeartRate))
                    .font(.custom("Nunito-Bold", size: 60))
                    .lineLimit(1)
                    .minimumScaleFactor(.leastNonzeroMagnitude)
                
                Text(getTaps())
                    .lineLimit(1)
                    .font(.custom("Nunito-SemiBold", size: 22))
                    .minimumScaleFactor(.leastNonzeroMagnitude)
            }
        }
    }
    
    func getTaps() -> String {
        return timerSession.countingState == .finished ? " " : "\(timerSession.timedTaps) \(timerSession.timedTaps == 1 ? "tap" : "taps")"
    }
    
    func getLabelText(finished: Bool, taps: Int, countdownCount: Double, showHeartRate: Bool) -> String {
        if finished {
            if showHeartRate {
                return timerSession.getBPM()
            } else {
                return "\(taps) \(taps == 1 ? "tap" : "taps")"
            }
            ///Could've used Terranries heres, but this is much more readable...
        } else {
            if countdownCount > 1 {
                return "\(Int(countdownCount))..."
            } else {
                return timerSession.getTimeRemaining()
            }
        }
    }
}


//MARK: ColoredButton

struct ColoredButton : View {
    var primaryColor : Color
    var secondaryColor : Color
    var title: String
    var heartMode: Bool
    var TSLink: Bool
    
    init(primaryColor: Color, secondaryColor: Color, title: String) {
        self.primaryColor = primaryColor
        self.secondaryColor = secondaryColor
        self.title = title
        heartMode = false
        self.TSLink = false
    }
    
    init(heartMode: Bool, TSLink: Bool) {
        self.primaryColor = TSLink ? grayPrim : Color("heart")
        self.secondaryColor = TSLink ? Color("heart") : graySec
        self.title = "BPM"
        self.heartMode = true
        self.TSLink = TSLink
    }
    
    var body : some View {
        ZStack {
            if !heartMode {
                ZStack {
                    Circle()
                        .foregroundColor(secondaryColor)
                    Text(title)
                        .font(.custom("Nunito-SemiBold", size: 19))
                        .foregroundColor(primaryColor)
                        .minimumScaleFactor(.leastNonzeroMagnitude)
                }
            } else {
                ZStack {
                    Circle()
                        .foregroundColor(secondaryColor)
                    VStack {
                        Image("heart.fill")
                            .foregroundColor(primaryColor)
                            .font(.largeTitle)
                            .offset(CGSize(width: 0, height: 7))
                        Text(TSLink ? "BPM" : "Count")
                            .font(.custom("Nunito-Regular", size: regularTextSize-3))
                                .foregroundColor(primaryColor)
                    }
                }
            }
        }.frame(width: Screen.width*0.22, height: Screen.width*0.22).shadow(radius: 2)
    }
}

//MARK: Global Colors and Buttons

var greenPrim = Color("green")
var greenSec = Color("greenAccent")
var orangePrim = Color("orange")
var orangeSec = Color("orangeAccent")
var grayPrim = Color("gray")
var graySec = Color("grayAccent")

var startButton = ColoredButton(primaryColor: greenPrim, secondaryColor: greenSec, title: "Start")
var resumeButton = ColoredButton(primaryColor: greenPrim, secondaryColor: greenSec, title: "Resume")
var pauseButton = ColoredButton(primaryColor: orangePrim, secondaryColor: orangeSec , title: "Pause")
var stopButton = ColoredButton(primaryColor: grayPrim, secondaryColor: graySec, title: "Stop")
var resetButton = ColoredButton(primaryColor: grayPrim, secondaryColor: graySec, title: "Reset")
var logButton = ColoredButton(primaryColor: orangePrim, secondaryColor: orangeSec, title: "Log")
