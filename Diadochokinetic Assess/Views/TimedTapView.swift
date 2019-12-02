//
//  TapHomeView.swift
//  Count-My-Taps
//
//  Created by Collin on 11/29/19.
//  Copyright © 2019 Ballygorey Apps. All rights reserved.
//

import SwiftUI

struct TimedTapView : View {
    
    @State var seconds = 3
    @EnvironmentObject var timerSession: TimerSession
    
    var body : some View {
        ZStack {
            Color("background").edgesIgnoringSafeArea(.top)
            VStack {
                ZStack(alignment: .bottom) {
                    if timerSession.countingState == .ready {
                        VStack {
                            Picker(selection: $seconds, label: Text("Secs")) {
                                ForEach(1...60, id: \.self) { time in
                                    Text("\(time)").tag(time <= 60 && time > 0 ? time : 3)
                                }
                            }
                            Spacer()
                        }.padding()
                    } else {
                        ZStack {
                            TimerRing(percent: timerSession.percent)
                                .stroke(Color(#colorLiteral(red: 0.4672634006, green: 0.7216928601, blue: 0.7848936915, alpha: 1)), lineWidth: 7)
                                .rotationEffect(.degrees(-90))
                                .aspectRatio(1, contentMode: .fit)
                                .padding(20)
                            CenterCircleText().environmentObject(timerSession)
                        }.padding(.bottom)
                    }
                }.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.4)//.background(Color.red)//.padding(.top)
                HStack {
                    LeftButton().environmentObject(timerSession)
                    Spacer()
                    RightButton(seconds: $seconds).environmentObject(timerSession)
                }.padding([.leading, .trailing], 30)

                TapButton().environmentObject(timerSession)
            }
        }
    }
}

struct TapButton : View {
    @EnvironmentObject var timerSession: TimerSession
    var body : some View {
        Button(action: {
            self.timerSession.taps += 1
        }) {
            Text("\(timerSession.countingState == .counting ? "Tap" : "Start Timer")")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(timerSession.countingState == .counting ? Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)) : Color(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)))
                .frame(width: UIScreen.main.bounds.width * 0.79, height: 150)
                .background(timerSession.countingState == .counting ? Color("tappingEnabled") : Color("tappingDisabled"))
                .cornerRadius(20)
                //.shadow(radius: 3)
                .padding()
        }.disabled(timerSession.countingState != .counting)
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
                cancelButton
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
            Text(getLabelText(finished: timerSession.countingState == .finished, taps: timerSession.taps, countdownCount: timerSession.countdownCount))
                .font(.system(size: 62))
            Text(getTaps())
        }
    }
    func getTaps() -> String {
        if timerSession.countingState == .finished {
            return ""
        } else {
            return "\(timerSession.taps) \(timerSession.taps == 1 ? "tap" : "taps")"
        }
    }
    func getLabelText(finished: Bool, taps: Int, countdownCount: Double) -> String {
        ///timerSession.countingState == .finished ? "\(timerSession.taps) \(timerSession.taps == 1 ? "tap" : "taps")" : timerSession.countdownCount > 0.15 ? "\(Int(timerSession.countdownCount))..." : getTime()
        ///Does that^    Lol
        if finished {
            return "\(taps) \(taps == 1 ? "tap" : "taps")"
        } else {
            if countdownCount > 0.15 {
                return "\(Int(countdownCount))..."
            } else {
                return getTime()
            }
        }
    }
    func getTime() -> String {
        let intTimeCount = Int(timerSession.timeCount)
        if intTimeCount == 60 {
            return "01:00"
        } else if  intTimeCount >= 10{
            return "00:\(intTimeCount)"
        } else {
            return "00:0\(intTimeCount)"
        }
    }
}

enum PossibleCountingStates {
    case ready
    case countdown
    case counting
    case paused
    case finished
}

var startButton = coloredButton(primaryColor: greenPrim, secondaryColor: greenSec, imageName: "play.fill")
var resumeButton = coloredButton(primaryColor: greenPrim, secondaryColor: greenSec, imageName: "playpause.fill")
var pauseButton = coloredButton(primaryColor: Color(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)), secondaryColor: Color(#colorLiteral(red: 0.3098039329, green: 0.2039215714, blue: 0.03921568766, alpha: 1)), imageName: "pause.fill")
var cancelButton = coloredButton(primaryColor: Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)), secondaryColor: Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)), imageName: "stop.fill")
var resetButton = coloredButton(primaryColor: Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)), secondaryColor: Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)), imageName: "arrow.2.circlepath")

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
            Circle()
                .stroke(secondaryColor, lineWidth: 2)
            Circle()
                .foregroundColor(secondaryColor)
                .frame(width: 79, height: 79)
            Image(systemName: imageName)
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .frame(width: 30, height: 30)
                .foregroundColor(primaryColor)
        }.frame(width: 85, height: 85)
    }
}

//struct TapHomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        TapHomeView()
//    }
//}
//    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
//    var timer: Timer = Timer.init()
