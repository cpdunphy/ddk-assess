//
//  RecordHistoryList.swift
//  Diadochokinetic Assess
//
//  Created by Collin Dunphy on 9/27/20.
//

import SwiftUI

struct RecordHistoryList: View {
    
    @EnvironmentObject var model : DDKModel
    
    @State private var showTrashConfirmationAlert : Bool = false
    @AppStorage("userLogCountTOTAL") var totalAssessments : Int = 0
    
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
                RecordRow(record: record)
            }.onDelete(perform: delete)
                
            Text("You have done \(totalAssessments) DDK \(totalAssessments == 1 ? "Assessment!" : "Assessments!")")
        }
        .navigationTitle("History")
        .alert(isPresented: $showTrashConfirmationAlert) {
            deleteAlert
        }
        .toolbar {
            Button(action: {
                showTrashConfirmationAlert = true
            }) {
                Image(systemName: "trash.fill")
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
//                model.ResetTimedMode()
            })
        )
    }
    
    func delete(at offsets: IndexSet) {
        model.records.remove(atOffsets: offsets)
    }
}


struct RecordHistoryList_Previews: PreviewProvider {
    static var previews: some View {
        RecordHistoryList()
    }
}
