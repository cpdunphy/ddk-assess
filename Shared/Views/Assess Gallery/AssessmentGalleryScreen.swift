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
                        assessmentGalleryType.label
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



extension Set: RawRepresentable where Element: Codable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode(Set<Element>.self, from: data)
        else {
            return nil
        }
        self = result
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}

extension Array: RawRepresentable where Element: Codable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode([Element].self, from: data)
        else {
            return nil
        }
        self = result
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}
