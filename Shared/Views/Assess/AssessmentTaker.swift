//
//  AssessmentTaker.swift
//  AssessmentTaker
//
//  Created by Collin Dunphy on 7/18/21.
//

import SwiftUI

extension AssessmentTaker {
    struct BuildingBlocks {}
}

struct AssessmentTaker: View {

    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var ddk: DDKModel

    @State var assessmentSettingsSelection: AssessmentType?

    var type: AssessmentType

    private let spacing: CGFloat = 12
    private let cornerRadius: Int = 15

    // MARK: - Body
    var body: some View {

        GeometryReader { geo in

            VStack(spacing: 0) {

                // Actual Assessment taking, customized to fit the given type
                VStack(spacing: spacing) {

                    VStack(spacing: spacing) {
                        statsDisplay
                            .frame(maxWidth: .infinity, maxHeight: .infinity)

                        HStack(spacing: spacing) {
                            controlButtons
                        }
                    }
                    .layoutPriority(2)

                    tapButtons
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .layoutPriority(2)

                }
                .scenePadding(.horizontal)
                .scenePadding(geo.safeAreaInsets.bottom != 0 ? .top : .vertical)
                .layoutPriority(1)

                // Required to keep the navigationBar pressed against the top of the view when now buttons or stats are available to display
                Spacer(minLength: 0)
                    .layoutPriority(0)

            }
        }

        // Navigation Bar
//        .safeAreaInset(edge: .top, spacing: 0) {
//            navigationBar
//                .background(.bar)
//        }
//        .background(Color(.systemGroupedBackground))
        .sheet(item: $assessmentSettingsSelection) { type in
            NavigationView {
                AssessmentOptions(type: type)
            }
        }
    }
}

struct AssessmentTaker_Previews: PreviewProvider {
    static var previews: some View {
        AssessmentTaker(type: .timed)
    }
}

// MARK: - Navigation Bar
extension AssessmentTaker {
    var navigationBar: some View {
        VStack(spacing: 0) {

            HStack {

                AssessmentGalleryIcon(type: type)

                VStack(alignment: .leading) {

                    Text(type.title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .lineLimit(1)

                    Text(ddk.assessCountDescription(type))
                        .foregroundColor(.secondary)
                        .font(.caption)
                        .lineLimit(1)
                }

                Spacer()

                HStack(spacing: 16) {

                    Button {
                        assessmentSettingsSelection = type
                    } label: {
                        Label("Options", systemImage: "ellipsis.circle")
                    }

                    Button {
                        dismiss()
                    } label: {
                        Label("Close", systemImage: "xmark.circle.fill")
                            .symbolRenderingMode(.hierarchical)
                            .foregroundColor(.gray)
                    }

                }
                .labelStyle(.iconOnly)
                .imageScale(.large)
                .font(.title3)

            }
            .padding()

            Divider()
                .background(.ultraThickMaterial)
        }

    }
}
