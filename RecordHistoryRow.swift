//
//  RecordHistoryRow.swift
//  RecordHistoryRow
//
//  Created by Collin Dunphy on 7/19/21.
//

import SwiftUI

struct RecordHistoryRow: View {
    
    @EnvironmentObject var model : DDKModel
    
    @Environment(\.dismiss) var dismiss
    
    @State private var recordGetInfoPopover: Bool = false
    @State private var deleteConfirmationIsPresented : Bool = false
    
    var record : AssessmentRecord
    @Binding var recordEditSelection: AssessmentRecord?
    
    var dateTimeFormat: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yy 'at' HH:mm"
        return formatter
    }
    
    
    var body: some View {
        HStack {
            Label(record.type.title, systemImage: record.type.icon)
                .font(.title3)
                .foregroundColor(record.type.color)
                .labelStyle(.iconOnly)
            
            VStack(alignment: .leading) {
                
                Text("\(record.taps) \(record.taps == 1 ? "tap" : "taps")")
                
                HStack {
                    Text(record.date, style: .time)
                    + Text(" — ")
                    + Text("\(record.durationDescription)")
                }
                .foregroundColor(.secondary)
                .font(.caption)

            }
            
            Spacer()
            
            if false { //TODO: Implement
                Image(systemName: "pin.circle.fill")
                    .symbolRenderingMode(.hierarchical)
                    .foregroundColor(.accentColor)
                    .imageScale(.small)
            }
        }
        .contextMenu {
            Button {
                recordGetInfoPopover = true
            } label: {
                Label("Get Info", systemImage: "info.circle")
            }
            
            Button {
                recordEditSelection = record
            } label: {
                Label("Edit", systemImage: "slider.horizontal.3")
            }
            
            pinButton
            
            Section {
                deleteButton
            }
        }
        .popover(isPresented: $recordGetInfoPopover, arrowEdge: .trailing) {
            RecordGeneralInfo(record)
        }
        .swipeActions {
            pinButton
            .tint(.accentColor)
            
            deleteButton
        }
        .confirmationDialog("Are you sure?", isPresented: $deleteConfirmationIsPresented) {
            //
            Button(role: .destructive) {
                model.deleteRecord(record)
            } label: {
                Text("Delete the assessment")
            }
            
        }
    }
    
    func getSecondsLengthDouble(_ time: Double) -> String {
        if time / 60 >= 1 {
            let send = String(format: "%.1f", time/60)
            return "\(send) \(send == "1.0" ? "min" : "mins")"
        } else {
            let send = String(format: "%.1f", time)
            return "\(send) \(send == "1.0" ? "sec" : "secs")"
        }
    }
    
    var deleteButton : some View {
        Button(role: .destructive) {
            if false { // Implement pinning system
                deleteConfirmationIsPresented = true
            } else {
                model.deleteRecord(record)
            }
        } label: {
            Label("Delete", systemImage: "trash")
        }
    }
    
    var pinButton: some View {
        Button {
            //TODO: Implement Save Button
        } label: {
            if false { //Implement favorite system
                Label("Unpin", systemImage: "pin.slash")
            } else {
                Label("Pin", systemImage: "pin")
            }
        }
    }
}

struct HistoryRecordButton_Previews: PreviewProvider {
    static var previews: some View {
        RecordHistoryRow(
            record: AssessmentRecord(date: Date(), taps: 7, type: .timed, duration: 15),
            recordEditSelection: .constant(nil)
        )
    }
}
