//
//  HistoryScreen.swift
//  Diadochokinetic Assess
//
//  Created by Collin Dunphy on 9/27/20.
//

import SwiftUI

struct HistoryScreen: View {
    
    @EnvironmentObject var model : DDKModel
    
    @AppStorage(StorageKeys.User.totalAssessments) var totalAssessments :   Int = 0
    @AppStorage(StorageKeys.History.sortBy) var sortBy :                    String = "Date"
    
    @State private var recordEditSelection :        AssessmentRecord? = nil
    @State private var showTrashConfirmationAlert : Bool = false
    
    // MARK: - List
    var list: some View {
        List {
            ForEach(model.allRecords, id: \.id) { record in
                RecordHistoryRow(
                    record: record,
                    recordEditSelection: $recordEditSelection
                )
            }
            
            Text("You have done \(totalAssessments) DDK \(totalAssessments == 1 ? "Assessment!" : "Assessments!")")
        }
    }
    
    // MARK: - Body
    var body: some View {
        
        list
            .navigationTitle("History")
        
        // Optional List Style Modifier (Done b/c sidebar style takes over on iPadOS)
        #if os(iOS)
            .listStyle(.insetGrouped)
        #endif
        
        // Record Editor
            .sheet(
                item: $recordEditSelection,
                onDismiss: { recordEditSelection = nil }
            ) { record in
                NavigationView { EditRecordScreen(record) }
            }
        
        // Delete All Logs Confirmation Dialog
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
        
        // Toolbar Controls
            .toolbar {
                Menu {
                    // TODO: Group / Sort Controls
                    Section {
                        Menu {
                            Picker("Sort By", selection: $sortBy) {
                                ForEach(["Kind", "Date", "Pinned"], id: \.self) {
                                    Text($0).tag($0)
                                }
                            }
                        } label: {
                            Label("Sort By", systemImage: "arrow.up.arrow.down")
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
}


struct HistoryScreen_Previews: PreviewProvider {
    static var previews: some View {
        HistoryScreen()
    }
}
