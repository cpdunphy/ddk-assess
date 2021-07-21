//
//  HistoryScreen.swift
//  Diadochokinetic Assess
//
//  Created by Collin Dunphy on 9/27/20.
//

import SwiftUI

struct HistoryScreen: View {
    
    @EnvironmentObject var model : DDKModel
    
    @AppStorage(StorageKeys.User.totalAssessments) var totalAssessments : Int = 0
    @AppStorage(StorageKeys.History.historyIsGrouped) var historyIsGrouped : Bool = false

    @State private var recordEditSelection: AssessmentRecord? = nil
    @State private var showTrashConfirmationAlert : Bool = false
    
    var body: some View {
        #if os(iOS)
        list
            .listStyle(InsetGroupedListStyle())
        #else
        list
        #endif
    }
    
    var list: some View {
        List {
            ForEach(model.records, id: \.id) { record in
                HistoryRecordButton(
                    record: record,
                    recordEditSelection: $recordEditSelection
                )
            }
            
            Text("You have done \(totalAssessments) DDK \(totalAssessments == 1 ? "Assessment!" : "Assessments!")")
        }
        .sheet(
            item: $recordEditSelection,
            onDismiss: { recordEditSelection = nil }
        ) { record in
            NavigationView { EditRecordScreen(record) }
        }
        .navigationTitle("History")
        .alert(
            "Delete Logs",
            isPresented: $showTrashConfirmationAlert,
            actions: {
                Button("Cancel", role: .cancel) { }
                
                Button("Delete", role: .destructive) {
                    model.records = []
                }
            },
            message: {
                Text("Are you sure you want to delete all logs?")
            }
        )
        .toolbar {
            Button(action: {
                showTrashConfirmationAlert = true
            }) {
                Label("Delete Logs", systemImage: "trash.fill")
            }
        }
    }
    
    var deleteAlert: Alert {
        Alert(
            title: Text("Delete Logs"),
            message: Text("Are you sure you want to delete all logs?"),
            primaryButton: .cancel(Text("Cancel")),
            secondaryButton: .destructive(Text("Delete"), action: {
                model.records = []
            })
        )
    }
    
    func delete(at offsets: IndexSet) {
        model.records.remove(atOffsets: offsets)
    }
    
    
    // MARK: - RecordHistoryRow
    struct RecordHistoryRow : View {
        @EnvironmentObject var timerSession : TimerSession
        
        var record : AssessmentRecord
        
        var body : some View {
            VStack(alignment: .leading) {
                
                Label(record.type.title, systemImage: "circle.fill")
                    .foregroundColor(record.type.color)
                
                HStack {
                    Text("\(record.taps) \(record.taps == 1 ? "tap" : "taps")")
                    Spacer()
                    Text(
                        record.type == .timed ?
                        getSecondsLength(time: Int(record.duration)) :
                            getSecondsLengthDouble(time: record.duration)
                    )
                }
                HStack {
                    HStack {
                        Text(dateDescription(date: record.date))
                            .font(.footnote)
                            .foregroundColor(.secondary)
                        Text("[\(dateToString(date: record.date))]")
                            .font(Font.footnote.monospacedDigit())
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    Text(record.type.title)
                        .font(.footnote)
                        .foregroundColor(Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)))
                }
                
                Text(record.date, style: .time)
                Text(record.date, style: .date)
                
                
                Text("[") + Text(record.date, style: .relative) + Text("]")
            }
        }
        
        func getSecondsLength(time: Int) -> String {
            if time / 60 >= 1 {
                return "\(time / 60) \(time / 60 == 1 ? "minute" : "minutes")"
            } else {
                return "\(time) \(time == 1 ? "second" : "seconds")"
            }
        }
        
        func getSecondsLengthDouble(time: Double) -> String {
            if time / 60 >= 1 {
                let send = String(format: "%.1f", time/60)
                return "\(send) \(send == "1.0" ? "minute" : "minutes")"
            } else {
                let send = String(format: "%.1f", time)
                return "\(send) \(send == "1.0" ? "second" : "seconds")"
            }
        }
        
        func dateDescription(date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yy 'at' HH:mm"
            return formatter.string(from: date)
        }
        
        
        func dateToString(date : Date) -> String {
            //            print("Calculating")
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
        }
    }
}


struct HistoryScreen_Previews: PreviewProvider {
    static var previews: some View {
        HistoryScreen()
    }
}
