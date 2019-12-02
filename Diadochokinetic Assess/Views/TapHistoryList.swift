//
//  TapHistoryList.swift
//  Count-My-Taps
//
//  Created by Collin on 11/29/19.
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
    @State var presentSettingsModal = false
    var body : some View {
        NavigationView {
            List {
                ForEach(timerSession.recordingsArr, id: \.self) { record in
                    RecordRow(record: record)
                }
            }
            .navigationBarTitle("History", displayMode: .inline)
            .navigationBarItems(
                leading: Button(action: {
                    self.presentSettingsModal.toggle()
                }) {
                    Image("gear")
                        .padding(0.0)
                        .imageScale(.large)
        
                },
                trailing: Button(action: {
                    self.showDeleteConf = true
                }) {
                    Image(systemName: "trash.fill")
                        .imageScale(.large)
//                        .foregroundColor(.red)
                }.alert(isPresented: $showDeleteConf) {
                    deleteAlert
                }
            )
                .sheet(isPresented: $presentSettingsModal) {
                    Settings(presentSettingsModal: self.$presentSettingsModal).environmentObject(self.timerSession)
            }
        }
    }
}

struct RecordRow : View {
    var record : Record
    var body : some View {
        VStack(alignment: .leading) {
            HStack {
                Text("\(record.taps) \(record.taps == 1 ? "tap" : "taps")")
                Spacer()
                Text("\(record.duration) \(record.duration == 1 ? "second" : "seconds")")
            }
            HStack {
                Text("\(dateToString(date: record.date))")
                .font(.subheadline)
                .foregroundColor(Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)))
                Spacer()
                Text("\(record.timed ? "Timed" : "Untimed")")
                    .font(.subheadline)
                    .foregroundColor(Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)))
            }
        }
    }
    func dateToString(date : Date) -> String {
        let interval = Date().timeIntervalSince(date)
        var str = 0
        print(interval < 0 ? "negative" : "posative")
        print("\(interval)")
        var unit : Units = .seconds
        if interval / 60.0 > 1 {
            str = Int(interval / 60.0)
            print("\(str) = Str")
            unit = .minutes
        } else {
            str = Int(interval)
        }
        print("\(str) = Str")
        if unit == .minutes {
            return "\(str) \(str == 1 ? "min Ago" : "mins Ago")"
        } else {
            return "\(str) \(str == 1 ? "sec Ago" : "secs Ago")"
        }
    }
    enum Units {
        case seconds
        case minutes
    }
}
