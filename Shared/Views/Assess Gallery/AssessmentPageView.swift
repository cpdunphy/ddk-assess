//
//  AssessmentPageView.swift
//  DDK
//
//  Created by Collin Dunphy on 10/4/25.
//

import SwiftUI

struct AssessmentPageView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Binding var tabSelection: AssessmentType
    @State private var index: Int = 0
    
    var body: some View {
        TabView(selection: $tabSelection) {
            AssessmentTaker(type: AssessmentType.timed)
                .tag(AssessmentType.timed)
            AssessmentTaker(type: AssessmentType.count)
                .tag(AssessmentType.count)
            AssessmentTaker(type: AssessmentType.heartRate)
                .tag(AssessmentType.heartRate)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .background(tabSelection.color, ignoresSafeAreaEdges: .all)
        .animation(.easeInOut(duration: 1), value: tabSelection)
        
        // Toolbar
        .navigationTitle(tabSelection.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Button {
                    dismiss()
                } label: {
                    Label("Testing", systemImage: "list.bullet.clipboard")
                }
                //                GlassyPageScrubber(count: 5, index: $index)
            }
            
            
            
            ToolbarItem(placement: .bottomBar) {
                Button {
                    dismiss()
                } label: {
                    Label("List", systemImage: "list.bullet")
                }
            }
        }
    }
}

#Preview {
    AssessmentPageView(tabSelection: .constant(.timed))
}
