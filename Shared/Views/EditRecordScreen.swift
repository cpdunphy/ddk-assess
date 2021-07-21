//
//  EditRecordScreen.swift
//  EditRecordScreen
//
//  Created by Collin Dunphy on 7/19/21.
//

import SwiftUI

struct EditRecordScreen: View {
    
    @EnvironmentObject var model : DDKModel
    
    @Environment(\.dismiss) var dismiss
    
    var record: AssessmentRecord
    
    @State private var draftRecord : AssessmentRecord
    
    @State private var deleteConfirmationIsPresented : Bool = false
    
    init(_ record: AssessmentRecord) {
        self.record = record
        _draftRecord = .init(initialValue: record)
    }
    
    var body: some View {
        Form {
            Section {
                
                Picker("Assessment Type", selection: $draftRecord.type) {
                    ForEach(AssessmentType.allCases) {
                        Text($0.title)
                            .tag($0)
                    }
                }
                
                DatePicker(
                    "Date & Time",
                    selection: $draftRecord.date,
                    displayedComponents: [.date, .hourAndMinute]
                )
                
                DisclosureGroup("Duration: \(draftRecord.durationDescription)") {
                
                    Stepper(
                        "Minutes",
                        onIncrement: {
                           
                            draftRecord.duration += 60
                            
                            if draftRecord.duration >= 3600 {
                                draftRecord.duration = 3599.9
                            }
                        }, onDecrement: {
                            
                            draftRecord.duration -= 60
                            
                            if draftRecord.duration < 0 {
                                draftRecord.duration = 0
                            }
                            
                        }
                    )
                    
                    
                    Stepper(
                        "Seconds",
                        onIncrement: {
                            draftRecord.duration += 1
                            
                            if draftRecord.duration >= 3600 {
                                draftRecord.duration = 3599.9
                            }
                        }, onDecrement: {
                            
                            draftRecord.duration -= 1
                            
                            if draftRecord.duration < 0 {
                                draftRecord.duration = 0
                            }
                            
                        }
                    )
                    
                    Stepper(
                        "Deciseconds",
                        onIncrement: {
                            draftRecord.duration += 0.1
                            
                            if draftRecord.duration >= 3600 {
                                draftRecord.duration = 3599.9
                            }
                        }, onDecrement: {
                            
                            draftRecord.duration -= 0.1
                            
                            if draftRecord.duration < 0 {
                                draftRecord.duration = 0
                            }
                            
                        }
                    )
                }
            }
            
            Section {
                Stepper("Taps: \(draftRecord.taps)", value: $draftRecord.taps)
                
            }
            
            Section {
                Button(role: .destructive) {
                    deleteConfirmationIsPresented = true
                } label: {
                    Label("Delete Assessment", systemImage: "trash")
                        .foregroundColor(.red)
                }
                .confirmationDialog("Are you sure?", isPresented: $deleteConfirmationIsPresented) {
                    Button(role: .destructive) {
                        //TODO: delete the item
                    } label: {
                        Text("Delete the assessment")
                    }
                    
                }
            }
            
        }
        .navigationTitle("Edit Record")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button {
                    dismiss()
                } label: {
                    Label("Cancel", systemImage: "gobackward")
                        .labelStyle(.titleOnly)
                }
            }
            
            ToolbarItem(placement: .automatic) {
                Button {
                    print("Saved button pressed!")
                    
                    guard let index = model.records.firstIndex(where: { $0.id == record.id }) else {
                        print("Error: Couldn't find index")
                        return
                    }

                    model.records[index] = draftRecord

                    dismiss()
                    
                } label: {
                    Label("Save", systemImage: "checkmark.circle")
                        .labelStyle(.titleOnly)
                }
            }
        }
        .onAppear {
            print("On Appear")
        }
        .onDisappear {
            print("On Disappear")
        }
    }
}

struct EditRecordScreen_Previews: PreviewProvider {
    static var previews: some View {
        EditRecordScreen(AssessmentRecord(date: Date(), taps: 7, type: .timed, duration: 15))
    }
}
