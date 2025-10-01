//
//  AssessmentGalleryGrid.swift
//  AssessmentGalleryGrid
//
//  Created by Collin Dunphy on 7/17/21.
//

import SwiftUI

enum AssessmentSortTypes: String, CaseIterable {
    case kind = "kind"
    case date = "date"

    var title: String {
        switch self {
        case .kind: return "Kind"
        case .date: return "Date"
        }
    }
}

struct AssessmentGalleryGrid: View {

    @EnvironmentObject var ddk: DDKModel

    @EnvironmentObject var timed: TimedAssessment
    @EnvironmentObject var count: CountingAssessment
    @EnvironmentObject var hr: HeartRateAssessment

    @Environment(\.colorScheme) var colorScheme

    @Namespace var namespace

    @AppStorage(StorageKeys.AssessGallery.sortBy) var sortBy: AssessmentSortTypes = Defaults.sortBy
    @AppStorage(StorageKeys.AssessGallery.sortAscending) var sortAscending: Bool = Defaults.sortAscending

    @Binding var assessmentSelection: AssessmentType?
    @Binding var assessmentSettingsSelection: AssessmentType?

    var columns = [
        GridItem(.adaptive(minimum: 150))
    ]

    func model(_ type: AssessmentType) -> AssessmentProtocol? {
        switch type {
        case .timed: return timed
        case .count: return count
        case .heartRate: return hr
        }
    }

    var dateModels: [AssessmentType] {
        let optionsWithModels = AssessmentType.allCases
            .compactMap { model($0) }
            .sorted { $0.dateLastUsed > $1.dateLastUsed }
            .map { $0.type }

        print(optionsWithModels)

        let others = AssessmentType.allCases.filter {
            !optionsWithModels.contains($0)
        }

        return optionsWithModels + others
    }

    var sortedTypes: [AssessmentType] {
        var types: [AssessmentType] {
            switch sortBy {
            case .date:
                return dateModels
            case .kind:
                return AssessmentType.allCases
            }
        }

        return sortAscending ? types : types.reversed()
    }

    var body: some View {
        ScrollView {
            VStack {

                //                // Favorited Assessments
                //                if !ddk.isFavoriteAssessmentsEmpty {
                //                    VStack(alignment: .leading) {
                //                        Text("Favorites".uppercased())
                //                            .font(.caption)
                //                            .foregroundColor(.secondary)
                //                            .padding(.leading)
                //
                //                        LazyVGrid(
                //                            columns: columns,
                //                            spacing: 12
                //                        ) {
                //                            ForEach(
                //                                sortedTypes.filter {
                //                                    ddk.assessmentTypeIsFavorite($0)
                //                                }
                //                            ) { type in
                //                                button(type)
                //                                    .matchedGeometryEffect(id: type.rawValue, in: namespace)
                //                            }
                //                        }
                //
                //                        Divider()
                //                            .padding(.vertical, 6)
                //                    }
                //                }

                // Not Favorited Assessments
                LazyVGrid(
                    columns: columns,
                    spacing: 12
                ) {
                    ForEach(
                        sortedTypes.filter {
                            !ddk.assessmentTypeIsFavorite($0)
                        }
                    ) { type in
                        button(type)
                            .matchedGeometryEffect(id: type.rawValue, in: namespace)
                    }
                }
            }
            .padding(.horizontal)
        }
    }

    func button(_ type: AssessmentType) -> some View {
        Button {
            triggerHapticFeedbackSuccess()
            assessmentSelection = type
        } label: {

            VStack(alignment: .leading) {

                Image(systemName: type.icon)
                    .font(.title)
                    .symbolVariant(.fill)
                    .padding(.bottom, 6)

                Spacer(minLength: 0)

                Text(type.title)
                    .font(.headline)
                    .lineSpacing(6)
                    .lineLimit(2)

                Text(ddk.assessCountDescription(type))
                    .font(.caption)
                    .truncationMode(.tail)
                    .lineLimit(1)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, minHeight: 85, maxHeight: .infinity, alignment: .leading)
            .padding(10)
            .background(
                LinearGradient(
                    colors: [
                        type.color,
                        type.color.adjust(by: colorScheme == .light ? 7.0 : -7.0) ?? .white
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                in: RoundedRectangle(cornerRadius: 10)
            )
        }
        .buttonStyle(.plain)
        .contextMenu {
            AssessmentGalleryContextMenuItems(
                type: type,
                assessmentSettingsSelection: $assessmentSettingsSelection
            )
        }
    }

    func triggerHapticFeedbackSuccess() {
        #if os(iOS)
            let hapticFeedback = UINotificationFeedbackGenerator()
            hapticFeedback.notificationOccurred(.success)
        #endif
    }
}

struct AssessmentGalleryGrid_Previews: PreviewProvider {
    static var previews: some View {
        AssessmentGalleryGrid(
            assessmentSelection: .constant(nil),
            assessmentSettingsSelection: .constant(nil)
        )
    }
}
