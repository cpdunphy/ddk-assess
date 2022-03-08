//
//  AssessmentGalleryScreen.swift
//  AssessmentGalleryScreen
//
//  Created by Collin Dunphy on 7/17/21.
//

import SwiftUI

struct AssessmentGalleryScreen: View {
    
    @Environment(\.dismissSearch) var dismissSearch
    
    @EnvironmentObject var model : DDKModel
    
    @AppStorage(StorageKeys.AssessGallery.sortBy) var sortBy : AssessmentSortTypes = Defaults.sortBy
    @AppStorage(StorageKeys.AssessGallery.sortAscending) var sortAscending : Bool = Defaults.sortAscending
    
    @State private var assessmentSettingsSelection  : AssessmentType? = nil
    @State private var assessmentSelection          : AssessmentType? = nil
    @State private var searchQuery: String = ""

    
    //MARK: - Body
    var body : some View {
        AssessmentGalleryGrid(
            assessmentSelection: $assessmentSelection,
            assessmentSettingsSelection: $assessmentSettingsSelection
        )
        
            .navigationTitle(NavigationItem.assess.title)
        
            .searchable(
                text: $searchQuery,
                placement: .sidebar,
                suggestions: {
                    ForEach(
                        !searchQuery.isEmpty ?
                        AssessmentType.allCases.filter {
                            $0.title.lowercased().contains(searchQuery.lowercased())
                        } : AssessmentType.allCases,
                        id: \.self
                    ) { type in
                        Button {
                            assessmentSelection = type
                            triggerHapticFeedbackSuccess()
                            dismissSearch()
                        } label: {
                            AssessmentListRow(
                                type: type,
                                searchQuery: $searchQuery,
                                assessmentConfigureSelection: $assessmentSettingsSelection
                            )
                        }
                    }
                }
            )
                
        // TODO: Sort Controls
            .toolbar {
                Menu {
                    Toggle("Ascending", isOn: $sortAscending)
                    
                    Picker("Sort By", selection: $sortBy) {
                        ForEach(AssessmentSortTypes.allCases, id: \.self) {
                            Text($0.title).tag($0)
                        }
                    }

                } label: {
                    Label("Sort By", systemImage: "arrow.up.arrow.down")
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
    
    func triggerHapticFeedbackSuccess() {
#if os(iOS)
        let hapticFeedback = UINotificationFeedbackGenerator()
        hapticFeedback.notificationOccurred(.success)
#endif
    }
}

struct AssessmentGalleryScreen_Previews: PreviewProvider {
    static var previews: some View {
        AssessmentGalleryScreen()
    }
}
