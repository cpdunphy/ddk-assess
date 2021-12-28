//
//  AssessmentGalleryScreen.swift
//  AssessmentGalleryScreen
//
//  Created by Collin Dunphy on 7/17/21.
//

import SwiftUI

extension AssessmentGalleryScreen {
    
    enum AssessmentGalleryType: String, Identifiable, CaseIterable {
        
        case grid, list
        
        var label: some View {
            switch self {
            case .grid:
                return Label("Icons", systemImage: "square.grid.2x2")
            case .list:
                return Label("List", systemImage: "list.bullet")
            }
        }
        
        var id: String {
            return self.rawValue
        }
    }
    
}

struct AssessmentGalleryScreen: View {
    
    @Environment(\.dismissSearch) var dismissSearch
    
    @EnvironmentObject var model : DDKModel
    
    @AppStorage(StorageKeys.AssessGallery.galleryType) private var galleryType : AssessmentGalleryType = .grid
    @AppStorage(StorageKeys.AssessGallery.sortBy) var sortBy : String = "kind"
    
    @State private var assessmentSettingsSelection  : AssessmentType? = nil
    @State private var assessmentSelection          : AssessmentType? = nil
    @State private var searchText: String = ""

    
    //MARK: - Body
    var body : some View {
        AssessmentGalleryGrid(
            assessmentSelection: $assessmentSelection,
            assessmentSettingsSelection: $assessmentSettingsSelection
        )
        
            .navigationTitle(NavigationItem.assess.title)
        
            .searchable(
                text: $searchText,
                placement: .sidebar,
                suggestions: {
                    ForEach(
                        !searchText.isEmpty ?
                        AssessmentType.allCases.filter { $0.title.lowercased().contains(searchText.lowercased()) }
                        : AssessmentType.allCases,
                        id: \.self
                    ) { type in
                        Button {
                            assessmentSelection = type
                            triggerHapticFeedbackSuccess()
                            dismissSearch()
                        } label: {
                            AssessmentListRow(
                                type: type,
                                searchQuery: $searchText,
                                assessmentSettingsSelection: $assessmentSettingsSelection
                            )
                        }
                    }
                }
            )
        
        // TODO: Sort Controls
            .toolbar {
                Menu {
                    Button("Assending") {
                        
                    }
                    
                    Picker("Sort By", selection: $sortBy) {
                        ForEach(["Kind", "Date"], id: \.self) {
                            Text($0).tag($0)
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
