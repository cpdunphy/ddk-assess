//
//  TapHomeView.swift
//  Count-My-Taps
//
//  Created by Collin on 11/29/19.
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
                            Text("Seconds")
                            VStack {
                                Picker(selection: $seconds, label: Text("")) {
                                    ForEach(1...60, id: \.self) { time in
                                        Text("\(time)").tag(time <= 60 && time > 0 ? time : 3)
                                    }
                                }.frame(width: 290, height: 235)
                            }.offset(CGSize(width: -5, height: 0))
                         }
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.45)
//                        .background(Color.orange)
                    } else {
                        ZStack {
                            ZStack {
                            ZStack {
                                Circle()
                                    .stroke(Color(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)), lineWidth: 10)
                                Circle()
                                    .trim(from: 0, to: CGFloat(timerSession.percent))
                                    .stroke(AngularGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.3803921569, green: 0.6431372549, blue: 0.7098039216, alpha: 1)), Color(#colorLiteral(red: 0.2784313725, green: 0.8274509804, blue: 0.7764705882, alpha: 1))]), center: .center), style: StrokeStyle(lineWidth: 10,  lineCap: timerSession.countingState == .finished ? .butt : .round))
                                    .rotationEffect(.degrees(-90))
                                    //.stroke(Color("AccentColor"), style: StrokeStyle(lineWidth: 10,  lineCap: timerSession.countingState == .finished ? .butt : .round))
                                //.foregroundColor(Color.red)
                            }//.frame(width: 295, height: 295)
                            .frame(
                             minWidth: 210,
                             idealWidth: 250,
                             maxWidth: 295,
                             minHeight: 210,
                             idealHeight: 250,
                             maxHeight: 295,
                             alignment: .center
                             )
                            CenterCircleText().environmentObject(timerSession)
                            }.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.3).padding(.bottom, 40) //TODO: Adjust with the UIScreen
                        }.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.45)//.padding(.bottom, UIScreen.main.bounds.width*0.15)
                        
                    }

                    //End of If-Statement, now in the bottom of ZStack
                    HStack {
                        LeftButton().environmentObject(timerSession)
                        Spacer()
                        RightButton(seconds: $seconds).environmentObject(timerSession)
                    }.padding([.leading, .trailing], UIScreen.main.bounds.width * 0.09)//.padding()
                    
                }.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.45)//.padding(.bottom)
                
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
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(timerSession.countingState == .counting ? Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)) : Color(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)))
                .frame(width: UIScreen.main.bounds.width * 0.85, height: UIScreen.main.bounds.height * 0.35)
                .background(getBackgroundColor())
                .cornerRadius(20)
            //                .padding(.horizontal)
        }.disabled(timerSession.countingState != .counting && timed)
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
            } else {
                self.timerSession.resume()
            }
        }) {
            if timerSession.countingState == .ready {
                startButton
            } else if timerSession.countingState == .counting || timerSession.countingState == .countdown {
                pauseButton
            } else {
                resumeButton
            }
        }.disabled(timerSession.countingState == .finished)
    }
}

struct CenterCircleText : View {
    @EnvironmentObject var timerSession : TimerSession
    var body : some View {
        VStack {
            Text(getLabelText(finished: timerSession.countingState == .finished, taps: timerSession.timedTaps, countdownCount: timerSession.countdownCount))
                .font(.system(size: 62))
            Text(getTaps())
        }
    }
    func getTaps() -> String {
        if timerSession.countingState == .finished {
            return ""
        } else {
            return "\(timerSession.timedTaps) \(timerSession.timedTaps == 1 ? "tap" : "taps")"
        }
    }
    func getLabelText(finished: Bool, taps: Int, countdownCount: Double) -> String {
        ///timerSession.countingState == .finished ? "\(timerSession.taps) \(timerSession.taps == 1 ? "tap" : "taps")" : timerSession.countdownCount > 0.15 ? "\(Int(timerSession.countdownCount))..." : getTime()
        ///Does that^    Lol
        if finished {
            return "\(taps) \(taps == 1 ? "tap" : "taps")"
        } else {
            if countdownCount > 1.15 {
                return "\(Int(countdownCount))..."
            } else {
                return timerSession.getTimeRemaining()
            }
        }
    }
    
}

var startButton2 = coloredButton(primaryColor: greenPrim, secondaryColor: greenSec, imageName: "play.fill")
var resumeButton2 = coloredButton(primaryColor: greenPrim, secondaryColor: greenSec, imageName: "playpause.fill")
var pauseButton2 = coloredButton(primaryColor: Color(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)), secondaryColor: Color(#colorLiteral(red: 0.3098039329, green: 0.2039215714, blue: 0.03921568766, alpha: 1)), imageName: "pause.fill")
var stopButton2 = coloredButton(primaryColor: Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)), secondaryColor: Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)), imageName: "stop.fill")
var resetButton2 = coloredButton(primaryColor: Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)), secondaryColor: Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)), imageName: "arrow.2.circlepath")

var startButton = coloredButton2(primaryColor: greenPrim, secondaryColor: greenSec, title: "Start")
var resumeButton = coloredButton2(primaryColor: greenPrim, secondaryColor: greenSec, title: "Resume")
var pauseButton = coloredButton2(primaryColor: Color(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)), secondaryColor: Color(#colorLiteral(red: 0.3098039329, green: 0.2039215714, blue: 0.03921568766, alpha: 1)), title: "Pause")
var stopButton = coloredButton2(primaryColor: Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)), secondaryColor: Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)), title: "Stop")
var resetButton = coloredButton2(primaryColor: Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)), secondaryColor: Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)), title: "Reset")
var logButton = coloredButton2(primaryColor: Color(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)), secondaryColor: Color(#colorLiteral(red: 0.3098039329, green: 0.2039215714, blue: 0.03921568766, alpha: 1)), title: "Log")

var greenPrim = Color("green")
var greenSec = Color("greenAccent")
var orangePrim = Color("orange")
var orangeSec = Color("orangeAccent")
var grayPrim = Color("gray")
var graySec = Color("grayAccent")


struct coloredButtonApple : View {
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
//            Circle()
//                .stroke(secondaryColor, lineWidth: 2)
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
                .font(.headline)

                .foregroundColor(primaryColor)
        }.frame(width: UIScreen.main.bounds.width*0.21, height: UIScreen.main.bounds.width*0.21)//.background(Color.purple)
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
