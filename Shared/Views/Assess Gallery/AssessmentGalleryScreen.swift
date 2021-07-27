//
//  AssessmentGalleryScreen.swift
//  AssessmentGalleryScreen
//
//  Created by Collin Dunphy on 7/17/21.
//

import SwiftUI

struct AssessmentGalleryScreen: View {
    
    @EnvironmentObject var model : DDKModel
    
    @AppStorage(StorageKeys.AssessGallery.galleryType) private var galleryType :    AssessmentGalleryType = .grid
    @AppStorage(StorageKeys.AssessGallery.sortBy) var sortBy :                      String = ""
    
    @State var assessmentSettingsSelection  : AssessmentType? = nil
    @State var assessmentSelection          : AssessmentType? = nil
    
    // MARK: - Assessment Switch
    @ViewBuilder
    var assessSwitch : some View {
        switch galleryType {
            
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
    
    //MARK: - Body
    var body : some View {
        assessSwitch
            .navigationTitle(NavigationItem.assess.title)
        
        // Toolbar Controls
            .toolbar {
                Menu {
                    // Gallery Controls
                    Section {
                        Picker("Gallery Type", selection: $galleryType) {
                            ForEach(AssessmentGalleryType.allCases) {
                                $0.label.tag($0)
                            }
                        }
                    }
                    
                    // TODO: Sort Controls
                    Section {
                        Menu("Sort By") {
                            Picker("Sort By", selection: $sortBy) {
                                ForEach(["Kind", "Date"], id: \.self) {
                                    Text($0).tag($0)
                                }
                            }
                        }
                    }
                } label: {
                    galleryType.label
                }

            }
        
        // Assessment Taker
            .fullScreenCover(item: $assessmentSelection) { type in
                AssessmentTaker(type: type)
            }
        
        // Configure Assessment Options
            .sheet(item: $assessmentSettingsSelection) { type in
                NavigationView {
                    AssessmentOptions(type: type)
                }
            }
    }
}

struct AssessmentGalleryScreen_Previews: PreviewProvider {
    static var previews: some View {
        AssessmentGalleryScreen()
    }
}
