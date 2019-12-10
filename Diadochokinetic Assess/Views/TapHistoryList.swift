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
    @State var presentSettingsModal = false
    var body : some View {
        NavigationView {
            List {
                ForEach(timerSession.recordingsArr, id: \.self) { record in
                    RecordRow(record: record)
                }
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
                    Image(systemName: "trash.fill")
                        .imageScale(.large)
                }.alert(isPresented: $showDeleteConf) {
                    deleteAlert
                }
            )
                .sheet(isPresented: $presentSettingsModal) {
                    Settings(presentSettingsModal: self.$presentSettingsModal).environmentObject(self.timerSession)
            }
        }
    }
    struct RecordRow : View {
        var record : Record
        var body : some View {
            VStack(alignment: .leading) {
                HStack {
                    Text("\(record.taps) \(record.taps == 1 ? "tap" : "taps")")
                        .font(.custom("Nunito-Regular", size: regularTextSize))
                    Spacer()
                    Text("\(record.duration) \(record.duration == 1 ? "second" : "seconds")")
                        .font(.custom("Nunito-Regular", size: regularTextSize))
                }
                HStack {
                    Text("\(dateToString(date: record.date))")
//                    .font(.subheadline)
                        .font(.custom("Nunito-Regular", size: regularTextSize-3))
                    .foregroundColor(Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)))
                    Spacer()
                    Text("\(record.timed ? "Timed" : "Untimed")")
//                        .font(.subheadline)
                        .font(.custom("Nunito-Regular", size: regularTextSize-3))
                        .foregroundColor(Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)))
                }
            }
        }
        func dateToString(date : Date) -> String {
            let interval = Date().timeIntervalSince(date)
            var str = 0
            var unit : Units = .seconds
            
            if interval / 60.0 > 1 {
                str = Int(interval / 60.0)
                unit = .minutes
            } else {
                str = Int(interval)
            }

            if unit == .minutes {
                return "\(str) \(str == 1 ? "min Ago" : "mins ago")"
            } else {
                return "\(str) \(str == 1 ? "sec Ago" : "secs ago")"
            }
        }

    }
    enum Units {
        case seconds
        case minutes
    }

}
