//
//  HistoryScreen.swift
//  Diadochokinetic Assess
//
//  Created by Collin Dunphy on 9/27/20.
//

import SwiftUI

struct HistoryScreen: View {
    
    @EnvironmentObject var model : DDKModel
    
    @AppStorage(StorageKeys.History.useGroups) var useGroups :              Bool = false
    @AppStorage(StorageKeys.History.sortBy) var sortBy :                    RecordSortTypes = .pinned
    
    @State private var recordEditSelection :        AssessmentRecord? = nil
    @State private var showTrashConfirmationAlert : Bool = false
        
    // MARK: - Grouped Records
    // Sorts and labels sections of records appropriately.
    var groupedRecords : [RecordGroup]? {
        
        if model.allRecords.isEmpty {
            // No records to display..
            return nil
        }
        
        switch sortBy {
            
        case .pinned: // Group by Pinned
            return [
                RecordGroup(title: "Pinned", records: model.pinnedRecords),
                RecordGroup(title: "Unpinned", records: model.records)
            ]
            
        case .date: // Group by Date
            
            // Use the standard library to group by date. (Alternative to using .filter)
            let groupedByDate: [String: [AssessmentRecord]] = Dictionary(
                grouping: model.allRecords,
                by : {
                    $0.date.formatted(
                        date: .numeric,
                        time: .omitted
                    )
                }
            )
            
            var groupedRecords: [RecordGroup] = []

            for (date, group) in groupedByDate {
                groupedRecords.append(
                    RecordGroup(title: date, records: group)
                )
            }
            
            return groupedRecords
            
        case .kind: // Group by Kind
            
            var groupedRecords: [RecordGroup] = []
            
            // Iterate over possible Types and filter the records by the type
            for type in AssessmentType.allCases {
                let filteredRecordsByType: [AssessmentRecord] = model.allRecords.filter { $0.type == type }
                
                groupedRecords.append(RecordGroup(title: type.title, records: filteredRecordsByType))
            }
            
            return groupedRecords
        }
    }
    
    // MARK: - List
    var listOfRecords: some View {
        List {
            if useGroups {
                if let groupedRecords = groupedRecords {
                    // Iterate over the keys in the dictionary
                    ForEach(groupedRecords, id: \.title) { group in //TODO: Dict is inherently unordered. Find some way to keep this consistent.
                        if !group.records.isEmpty {
                            // Grouped Section with a Key and existent Records.
                            sectionOfRecordHistory(group.title, group.records)
                        }
                    }
                } else {
                    Text("Go do your first assessment!")
                }
            } else {
                // Show all records by time, regardless of "GroupBy"
                if !model.allRecords.isEmpty {
                    sectionOfRecordHistory(nil, model.allRecords)
                } else {
                    Text("Go do your first assessment!")
                }
            }
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
                                    ForEach(RecordSortTypes.allCases, id: \.self) {
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

extension HistoryScreen {
    
    // MARK: - RecordGroup
    struct RecordGroup {
        var title: String?
        var records: [AssessmentRecord]
    }
}

extension HistoryScreen {
    
    // MARK: - SortTypes
    enum RecordSortTypes : String, CaseIterable {
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
}

struct HistoryScreen_Previews: PreviewProvider {
    static var previews: some View {
        HistoryScreen()
    }
}
