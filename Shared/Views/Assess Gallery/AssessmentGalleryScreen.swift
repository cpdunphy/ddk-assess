//
//  AssessmentGalleryScreen.swift
//  AssessmentGalleryScreen
//
//  Created by Collin Dunphy on 7/17/21.
//

import SwiftUI

struct AssessmentGalleryScreen: View {
    
    @EnvironmentObject var model : DDKModel
    
    @AppStorage(StorageKeys.AssessGallery.galleryType) private var assessmentGalleryType : AssessmentGalleryType = .grid
    @AppStorage(StorageKeys.AssessGallery.galleryIsGrouped) var galleryIsGrouped : Bool = false

    @State var assessmentSettingsSelection  : AssessmentType? = nil
    @State var assessmentSelection          : AssessmentType? = nil
    
    @ViewBuilder
    var assessSwitch : some View {
        switch assessmentGalleryType {
        
        // Gallery Grid
        case .grid:
            AssessmentGalleryGrid(
                assessmentSelection: $assessmentSelection,
                assessmentSettingsSelection: $assessmentSettingsSelection
            )
            
        // Gallery List
        case .list:
            AssessmentGalleryList(
                assessmentSelection: $assessmentSelection,
                assessmentSettingsSelection: $assessmentSettingsSelection
            )
        }
    }
    
    var body : some View {
        assessSwitch
            .toolbar {
                toolbarMenu
            }
            .navigationTitle(NavigationItem.assess.title)
            .fullScreenCover(item: $assessmentSelection) { type in
                AssessmentTaker(type: type)
            }
            .sheet(item: $assessmentSettingsSelection) { type in
                NavigationView {
                    AssessmentOptions(type: type)
                }
            }
    }
    
    var toolbarMenu : some View {
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
            Section {
                Toggle("Use Groups", isOn: $galleryIsGrouped)
                
                if galleryIsGrouped {
                    Menu("Group By") {
                        Picker("Group Selection", selection: .constant("Kind")) {
                            ForEach(["Kind", "Date"], id: \.self) {
                                Text($0).tag($0)
                            }
                        }
                    }
                }
            }
        } label: {
            assessmentGalleryType.label
        }
    }
}

struct AssessmentGalleryScreen_Previews: PreviewProvider {
    static var previews: some View {
        AssessmentGalleryScreen()
    }
}
