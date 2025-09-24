//
//  AssessmentGalleryScreen.swift
//  AssessmentGalleryScreen
//
//  Created by Collin Dunphy on 7/17/21.
//

import SwiftUI

struct AssessmentGalleryScreen: View {

    @Environment(\.dismissSearch) var dismissSearch

    @EnvironmentObject var model: DDKModel

    @AppStorage(StorageKeys.AssessGallery.sortBy) var sortBy: AssessmentSortTypes = Defaults.sortBy
    @AppStorage(StorageKeys.AssessGallery.sortAscending) var sortAscending: Bool = Defaults.sortAscending

    @State private var assessmentSettingsSelection: AssessmentType? = nil
    @State private var assessmentSelection: AssessmentType? = nil
    @State private var searchQuery: String = ""

    //MARK: - Body
    var body: some View {
        AssessmentGalleryGrid(
            assessmentSelection: $assessmentSelection,
            assessmentSettingsSelection: $assessmentSettingsSelection
        )
        .navigationTitle(NavigationItem.assess.title)

        #if !os(macOS)
            // Assessment Taker
            .fullScreenCover(item: $assessmentSelection) { type in
                AssessmentTaker(type: type)
            }
        #endif

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
