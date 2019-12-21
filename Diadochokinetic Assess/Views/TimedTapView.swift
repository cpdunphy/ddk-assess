//
//  TapHomeView.swift
//  Diadochokinetic Assess
//
//  Created by Collin on 12/1/19.
//  Copyright © 2019 Ballygorey Apps. All rights reserved.
//

import SwiftUI

struct TimedTapView : View {
    
    @State var seconds = defaults.integer(forKey: secondsKey)
    @EnvironmentObject var timerSession: TimerSession
    var body : some View {
        ZStack {
            Color("background").edgesIgnoringSafeArea(.top)
            VStack {
                ZStack(alignment: .bottom) {
                    if timerSession.countingState == .ready {
                        ZStack(alignment: .top) {
                            Text("Set the Seconds")
                                .font(.custom("Nunito-SemiBold", size: 22))
                                .padding(.bottom, 7)
                            VStack {
                                Picker(selection: $seconds, label: Text("")) {
                                    ForEach(1...60, id: \.self) { time in
                                        Text("\(time)").font(.custom("Nunito-SemiBold", size: 20)).tag(time <= 60 && time > 0 ? time : 3)
                                    }
                                }.frame(width: 290, height: 235)
                            }.offset(CGSize(width: -5, height: 0))
                        }
                        .frame(width: Screen.width, height: Screen.height * 0.45)
                        //                        .background(Color.orange)
                    } else {
                        ZStack {
                            ZStack {
                                ZStack {
                                    Circle()
                                        .foregroundColor(Color("RectangleBackground"))
                                    Circle()
                                        .stroke(Color(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)), lineWidth: 10)
                                    Circle()
                                        .trim(from: -1, to: CGFloat(timerSession.percent))
                                        .stroke(AngularGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.214261921, green: 0.3599105657, blue: 0.5557389428, alpha: 1)), Color(#colorLiteral(red: 0.2784313725, green: 0.8274509804, blue: 0.7764705882, alpha: 1))]), center: .center), style: StrokeStyle(lineWidth: 10,  lineCap: timerSession.countingState == .finished ? .butt : .round, lineJoin: .miter))
                                        .rotationEffect(.degrees(-90))
                                    //.stroke(Color("AccentColor"), style: StrokeStyle(lineWidth: 10,  lineCap: timerSession.countingState == .finished ? .butt : .round))
                                    //.foregroundColor(Color.red)
                                }//.frame(width: 295, height: 295)
                                    .frame(
                                        minWidth: 210,
                                        idealWidth: 240,
                                        maxWidth: 295,
                                        minHeight: 210,
                                        idealHeight: 240,
                                        maxHeight: 295,
                                        alignment: .center
                                )
                                CenterCircleText().environmentObject(timerSession)
                            }.frame(width: Screen.width, height: Screen.height * 0.3).padding(.bottom, 40) //TODO: Adjust with the UIScreen
                        }.frame(width: Screen.width, height: Screen.height * 0.45)//.padding(.bottom, Screen.width*0.15)
                        
                    }
                    
                    //End of If-Statement, now in the bottom of ZStack
                    HStack {
                        LeftButton().environmentObject(timerSession)
                        Spacer()
                        RightButton(seconds: $seconds).environmentObject(timerSession)
                    }.padding([.leading, .trailing], Screen.width * 0.09)//.padding()
                    
                }.frame(width: Screen.width, height: Screen.height * 0.45)//.padding(.bottom)
                
                TapButton(timed: true).environmentObject(timerSession)
                
            }
        }
        .onDisappear(perform: {
            defaults.set(self.seconds, forKey: secondsKey)
        })
    }
}

struct TapButton : View {
    @EnvironmentObject var timerSession: TimerSession
    var timed : Bool
    var body : some View {
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
            Text(getText())
                //                .font(.largeTitle)
                //                .fontWeight(.bold)
                .font(.custom("Nunito-Bold", size: 50))
                .foregroundColor(timerSession.countingState != .counting && timed ? Color(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)) : Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)))
                .frame(width: Screen.width * 0.85, height: Screen.height * 0.35)
                .background(getBackgroundColor())
                .cornerRadius(20)
            //                .padding(.horizontal)
        }.disabled(timerSession.countingState != .counting && timed).shadow(radius: timerSession.countingState != .counting && timed ? 0 : 2)
        //.padding(.bottom)
    }
    
    func getBackgroundColor() -> Color {
        if timed {
            return timerSession.countingState == .counting ? Color("tappingEnabled") : Color("tappingDisabled")
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

struct LeftButton : View {
    @EnvironmentObject var timerSession : TimerSession
    var body : some View {
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
}

struct RightButton : View {
    @EnvironmentObject var timerSession : TimerSession
    @Binding var seconds: Int
    var body : some View {
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
                HeartButton().environmentObject(timerSession)
            } else {
                resumeButton
            }
        }//.disabled(timerSession.countingState == .finished)
    }
}
struct HeartButton : View {
    var color = Color("heart")
    var background = Color("grayAccent")
    @EnvironmentObject var timerSession : TimerSession
    var body : some View {
        ZStack {
            Circle()
                .foregroundColor(timerSession.showHeartRate ? color : background)
                //.shadow(radius: 2)
            VStack {
                Image("heart.fill")
                    .foregroundColor(timerSession.showHeartRate ? grayPrim : color)
                    .font(.largeTitle)
                    .offset(CGSize(width: 0, height: 7))
                Text("BPM")
                    .font(.custom("Nunito-Regular", size: regularTextSize-3))
                    .foregroundColor(timerSession.showHeartRate ? grayPrim : color)
//                    .foregroundColor(timerSession.showHeartRate ? background : color)
            }
        }.frame(width: Screen.width*0.22, height: Screen.width*0.22).shadow(radius: 2)
    }
}
struct CenterCircleText : View {
    @EnvironmentObject var timerSession : TimerSession
    var body : some View {
        ZStack {
            if timerSession.countingState != .finished { // || timerSession.showHeartRate
                Handle().offset(CGSize(width: 0, height: 22))
            }
            VStack(spacing: 10) {
                Text(getLabelText(finished: timerSession.countingState == .finished, taps: timerSession.timedTaps, countdownCount: timerSession.countdownCount, showHeartRate: timerSession.showHeartRate))
                    .font(.custom("Nunito-Bold", size: timerSession.countingState == .finished ? 50 : 60))
                    .kerning(-2.0)
                
                
                Text(getTaps())
                    .font(.custom("Nunito-SemiBold", size: 20))
            }
        }
    }
    func getTaps() -> String {
        if timerSession.countingState == .finished {
            /*if timerSession.showHeartRate {
                return "\(timerSession.timedTaps) \(timerSession.timedTaps == 1 ? "tap" : "taps")"
            }*/ ///shows taps under heartrate when heartrate enabled
            return ""
        } else {
            return "\(timerSession.timedTaps) \(timerSession.timedTaps == 1 ? "tap" : "taps")"
        }
    }
    func getLabelText(finished: Bool, taps: Int, countdownCount: Double, showHeartRate: Bool) -> String {
        if finished {
            if showHeartRate {
                return timerSession.getBPM()
            } else {
                return "\(taps) \(taps == 1 ? "tap" : "taps")"
            }
        } else {
            if countdownCount > 1 {
                return "\(Int(countdownCount))..."
            } else {
                return timerSession.getTimeRemaining()
            }
        }
    }
    
    
    
}




struct coloredButton2 : View {
    var primaryColor : Color
    var secondaryColor : Color
    var title: String
    
    var body : some View {
        ZStack {
            Circle()
                .foregroundColor(secondaryColor)
            Text(title)
                .font(.custom("Nunito-SemiBold", size: 19))
                .foregroundColor(primaryColor)
        }.frame(width: Screen.width*0.22, height: Screen.width*0.22).shadow(radius: 2)
        //.background(Color.purple)
        /*.frame(
         minWidth: 50,
         idealWidth: 60,
         maxWidth: 85,
         minHeight: 50,
         idealHeight: 60,
         maxHeight: 80,
         alignment: .center
         )*/
    }
}


var greenPrim = Color("green")
var greenSec = Color("greenAccent")
var orangePrim = Color("orange")
var orangeSec = Color("orangeAccent")
var grayPrim = Color("gray")
var graySec = Color("grayAccent")


var startButton = coloredButton2(primaryColor: greenPrim, secondaryColor: greenSec, title: "Start")
var resumeButton = coloredButton2(primaryColor: greenPrim, secondaryColor: greenSec, title: "Resume")
var pauseButton = coloredButton2(primaryColor: orangePrim, secondaryColor: orangeSec , title: "Pause")
var stopButton = coloredButton2(primaryColor: grayPrim, secondaryColor: graySec, title: "Stop")
var resetButton = coloredButton2(primaryColor: grayPrim, secondaryColor: graySec, title: "Reset")
var logButton = coloredButton2(primaryColor: orangePrim, secondaryColor: orangeSec, title: "Log")


/*var startButton2 = coloredButton(primaryColor: greenPrim, secondaryColor: greenSec, imageName: "play.fill")
 var resumeButton2 = coloredButton(primaryColor: greenPrim, secondaryColor: greenSec, imageName: "playpause.fill")
 var pauseButton2 = coloredButton(primaryColor: orangePrim, secondaryColor: orangeSec, imageName: "pause.fill")
 var stopButton2 = coloredButton(primaryColor: grayPrim, secondaryColor: graySec, imageName: "stop.fill")
 var resetButton2 = coloredButton(primaryColor: grayPrim, secondaryColor: graySec, imageName: "arrow.2.circlepath")*/

/*struct coloredButtonApple : View {
 var primaryColor : Color
 var secondaryColor : Color
 var text : String
 
 var body : some View {
 ZStack {
 Circle()
 .stroke(secondaryColor, lineWidth: 2)
 Circle()
 .foregroundColor(secondaryColor)
 .frame(width: 79, height: 79)
 Text(text)
 .foregroundColor(primaryColor)
 }.frame(width: 85, height: 85)
 }
 }
 
 
 struct coloredButton : View {
 var primaryColor : Color
 var secondaryColor : Color
 var imageName: String
 
 var body : some View {
 ZStack {
 Circle()
 .foregroundColor(secondaryColor)
 .frame(width: 79, height: 79)
 Image(systemName: imageName)
 .resizable()
 .aspectRatio(1, contentMode: .fit)
 .frame(width: 30, height: 30)
 .foregroundColor(primaryColor)
 }.frame(width: 85, height: 85)//.background(Color.purple)
 }
 }*/

