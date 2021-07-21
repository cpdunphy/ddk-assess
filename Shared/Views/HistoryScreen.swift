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
                RecordHistoryRow(
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
            Menu {
                // Group / Sort Controls
                Section {
                    Button {
                        historyIsGrouped.toggle()
                    } label: {
                        Text("Use Groups")
                    }
                    if historyIsGrouped {
                        Menu("Group By") {
                            Picker("Group Selection", selection: .constant("Kind")) {
                                ForEach(["Kind", "Date", "Pinned"], id: \.self) {
                                    Text($0).tag($0)
                                }
                            }
                        }
                    }
                }
                
                // Delete All Logs Button
                Section {
                    Button(role: .destructive) {
                        showTrashConfirmationAlert = true
                    } label: {
                        Label("Delete Logs", systemImage: "trash.fill")
                    }
                }
            } label: {
                Label("More", systemImage: "ellipsis.circle")
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
}


struct HistoryScreen_Previews: PreviewProvider {
    static var previews: some View {
        HistoryScreen()
    }
}
