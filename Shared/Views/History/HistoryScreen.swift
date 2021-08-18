//
//  HistoryScreen.swift
//  Diadochokinetic Assess
//
//  Created by Collin Dunphy on 9/27/20.
//

import SwiftUI

enum HistorySortTypes : String, CaseIterable {
    case kind = "kind"
    case date = "date"
    case pinned = "pinned"
    
    var title : String {
        switch self {
        case .kind:     return "Kind"
        case .date:     return "Date"
        case .pinned:   return "Pinned"
        }
    }
}




struct HistoryScreen: View {
    
    @EnvironmentObject var model : DDKModel
    
    @AppStorage(StorageKeys.User.totalAssessments) var totalAssessments :   Int = 0
    @AppStorage(StorageKeys.History.useGroups) var useGroups :              Bool = false
    @AppStorage(StorageKeys.History.sortBy) var sortBy :                    HistorySortTypes = .pinned
    
    @State private var recordEditSelection :        AssessmentRecord? = nil
    @State private var showTrashConfirmationAlert : Bool = false
    
    
    // Grouped Records Switch. Sorts and labels sections of records appropriately.
    var groupedRecords : [String:[AssessmentRecord]] {
        switch sortBy {
        case .pinned:
            return ["Pinned" : model.pinnedRecords, "Unpinned": model.records]
        default:
            return ["" : model.allRecords]
        }
    }
    
    // MARK: - List 
    var listOfRecords: some View {
        List {
            if useGroups {
                
                // Iterate over the keys in the dictionary
                ForEach(Array(groupedRecords.keys), id: \.self) { key in //TODO: Dict is inherently unordered. Find some way to keep this consistent.
                    if let records = groupedRecords[key] ?? [] {
                        if !records.isEmpty {
                            
                            // Grouped Section with a Key and existent Records.
                            sectionOfRecordHistory(key, records)
                        }
                    }
                }
            } else {
                
                // Show all records by time, regardless of "GroupBy"
//                Section {
                    sectionOfRecordHistory(nil, model.allRecords)
//                }
            }
            
            Text("You have done \(totalAssessments) DDK \(totalAssessments == 1 ? "Assessment!" : "Assessments!")")
        }
    }
    
    // MARK: - sectionOfRecordHistory
    /// Creates a section in the list and loops over the provided records
    /// - Parameters:
    ///   - header: Section title string, shown above the section of records
    ///   - records: Array of Records to loop over
    @ViewBuilder
    func sectionOfRecordHistory(_ header: String? = nil, _ records: [AssessmentRecord]) -> some View {
        
        // Check to see if header exists
        if let header = header {
            
            // Check to see if header has a value, if not, don't add a header to the section.
            if !header.isEmpty {
                Section(header) {
                    ForEach(records, id: \.id) { record in
                        RecordHistoryRow(
                            record: record,
                            recordEditSelection: $recordEditSelection
                        )
                    }
                }
            } else {
                Section {
                    ForEach(records, id: \.id) { record in
                        RecordHistoryRow(
                            record: record,
                            recordEditSelection: $recordEditSelection
                        )
                    }
                }
            }
            
        } else {
            Section {
                ForEach(records, id: \.id) { record in
                    RecordHistoryRow(
                        record: record,
                        recordEditSelection: $recordEditSelection
                    )
                }
            }
        }
    }
    
    
    // MARK: - Body
    var body: some View {
        
        listOfRecords
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
                        
                        Toggle("Use Groups", isOn: $useGroups)
                        
                        if useGroups {
                            Menu {
                                Picker("Group By", selection: $sortBy) {
                                    ForEach(HistorySortTypes.allCases, id: \.self) {
                                        Text($0.title).tag($0)
                                    }
                                }
                            } label: {
                                Label("Group By", systemImage: "arrow.up.arrow.down")
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
}


struct HistoryScreen_Previews: PreviewProvider {
    static var previews: some View {
        HistoryScreen()
    }
}
