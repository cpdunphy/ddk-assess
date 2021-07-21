//
//  AssessmentGalleryScreen.swift
//  AssessmentGalleryScreen
//
//  Created by Collin Dunphy on 7/17/21.
//

import SwiftUI

struct AssessmentGalleryScreen: View {
    
    @EnvironmentObject var model : DDKModel
    
    @AppStorage("assessment_gallery_type") private var assessmentGalleryType : AssessmentGalleryType = .grid
    
    @State var assessmentSettingsSelection  : AssessmentType? = nil
    @State var assessmentSelection          : AssessmentType? = nil
    
    var body : some View {
        assessSwitch
            .toolbar {
                ToolbarItem(placement: ToolbarItemPlacement.navigationBarTrailing) {
                    Menu {
                        // Gallery Controls
                        Section {
                            Picker("Gallery Type", selection: $assessmentGalleryType) {
                                ForEach(AssessmentGalleryType.allCases) {
                                    $0.label.tag($0)
                                }
                            }
                        }
                        // TODO: Sort Controls
                    } label: {
                        Label("More", systemImage: "ellipsis.circle")
                    }
                }
            }
            .fullScreenCover(item: $assessmentSelection) { type in
                AssessmentTaker(type: type)
            }
            .sheet(item: $assessmentSettingsSelection) { type in
                NavigationView {
                    AssessmentOptions(type: type)
                }
            }
            .navigationTitle(NavigationItem.assess.title)
    }
    
    @ViewBuilder
    var assessSwitch : some View {
        switch assessmentGalleryType {
        case .grid:
            AssessmentGalleryGrid(
                assessmentSelection: $assessmentSelection,
                assessmentSettingsSelection: $assessmentSettingsSelection
            )
        case .list:
            AssessmentGalleryList(
                assessmentSelection: $assessmentSelection,
                assessmentSettingsSelection: $assessmentSettingsSelection
            )
        }
    }
}

struct AssessmentGalleryScreen_Previews: PreviewProvider {
    static var previews: some View {
        AssessmentGalleryScreen()
    }
}



