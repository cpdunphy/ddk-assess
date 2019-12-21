//
//  TapHistoryList.swift
//  Diadochokinetic Assess
//
//  Created by Collin on 12/1/19.
//  Copyright © 2019 Ballygorey Apps. All rights reserved.
//

import SwiftUI

struct TapHistoryList : View {
    @State private var showDeleteConf = false
    @EnvironmentObject var timerSession : TimerSession
    var deleteAlert: Alert {
        Alert(
            title: Text("Delete Logs"),
            message: Text("Are you sure you want to delete all logs?"),
            primaryButton: .cancel(Text("Cancel")),
            secondaryButton: .destructive(Text("Delete"), action: {
                self.timerSession.recordingsArr = []
                self.timerSession.reset()
            })
        )
    } 
    @Binding var presentSettingsModal : Bool
    var body : some View {
        NavigationView {
            List {
                //Text("You have done \(timerSession.logCount) logs!")
                //Text("You have done \(userTotalCount) logs in total!")

                ForEach(timerSession.recordingsArr, id: \.self) { record in
                    RecordRow(record: record)
                }
                .onDelete(perform: delete)
            }
            .navigationBarTitle(Text("History").font(.custom("Nunito-Regular", size: regularTextSize)), displayMode: .inline)
            .navigationBarItems(
                leading: Button(action: {
                    self.presentSettingsModal.toggle()
                }) {
                    Image("gear")
                        .font(.title)
                        .imageScale(.medium)
                },
                trailing: Button(action: {
                    self.showDeleteConf = true
                }) {
                    Image("trash.fill")
                        .font(.title)
                        .imageScale(.small)
                }.alert(isPresented: $showDeleteConf) {
                    deleteAlert
                }
            )
                .sheet(isPresented: $presentSettingsModal) {
                    Settings(presentSettingsModal: self.$presentSettingsModal).environmentObject(self.timerSession)
            }
        }
    }
    
    func delete(at offsets: IndexSet) {
        timerSession.recordingsArr.remove(atOffsets: offsets)
    }
    
    struct RecordRow : View {
        var record : Record
        var body : some View {
            VStack(alignment: .leading) {
                HStack {
                    Text("\(record.taps) \(record.taps == 1 ? "tap" : "taps")")
                        .font(.custom("Nunito-Regular", size: regularTextSize))
                    Spacer()
                    Text(getSecondsLength(time: record.duration))
                        .font(.custom("Nunito-Regular", size: regularTextSize))
                }
                HStack {
                    HStack {
                        Text(dateDescription(date: record.date))
                            .font(.custom("Nunito-Regular", size: regularTextSize-3))
                            .foregroundColor(Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)))
                        Text("[\(dateToString(date: record.date))]")
                        .font(.custom("Nunito-Regular", size: regularTextSize-3))
                        .foregroundColor(Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)))
                    }
                    Spacer()
                    Text("\(record.timed ? "Timer" : "Count")")
//                        .font(.subheadline)
                        .font(.custom("Nunito-Regular", size: regularTextSize-3))
                        .foregroundColor(Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)))
                }
            }
        }
        func getSecondsLength(time: Int) -> String {
            if time / 60 >= 1 {
                return "\(time / 60) \(time / 60 == 1 ? "minute" : "minutes")"
            } else {
                return "\(time) \(time == 1 ? "second" : "seconds")"
            }
        }
        
        func dateDescription(date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yy 'at' HH:mm"
            return formatter.string(from: date)
        }
        
        func dateToString(date : Date) -> String {
            let interval = Date().timeIntervalSince(date)
            var str = 0
            var unit : TimeUnits = .seconds
            
            if interval / 60.0 / 60.0 / 60.0 > 1 {
                str = Int(interval / 60.0 / 60.0 / 60.0)
                unit = .days
            } else if interval / 60.0 / 60.0 > 1 {
                str = Int(interval / 60.0 / 60.0)
                unit = .hours
            } else if interval / 60.0 > 1 {
                str = Int(interval / 60.0)
                unit = .minutes
            } else {
                str = Int(interval)
            }
            
            return "\(str) \(str == 1 ? "\(unit.rawValue) ago" : "\(unit.rawValue)s ago")"
            
            /*switch unit {
            case .days:
                return "str"
                case .hours:
                    return "\(str) \(str == 1 ? "hour ago" : "hours ago")"
                case .minutes:
                    return "\(str) \(str == 1 ? "min ago" : "mins ago")"
                case .seconds:
                    return "\(str) \(str == 1 ? "sec ago" : "secs ago")"
            }*/
        }
    }
}
