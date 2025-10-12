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

    @State private var assessmentSettingsSelection: AssessmentType?
    @State private var assessmentSelection: AssessmentType?
    @State private var searchQuery: String = ""
    
    @State private var showSettings: Bool = false
    @State private var showAssessmentTaker: Bool = false
    
    // MARK: - Body
    var body: some View {
        AssessmentGalleryGrid(
            assessmentSelection: $assessmentSelection,
            assessmentSettingsSelection: $assessmentSettingsSelection,
            showAssessmentTaker: $showAssessmentTaker
        )
        .navigationTitle("Assess")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showSettings = true
                } label: {
                    Label("Options", systemImage: "ellipsis")
                }
            }
        }
//        .fullScreenCover(isPresented: $showAssessmentTaker) {
//            AssessmentPageView(
//                tabSelection: Binding(
//                    get: { assessmentSelection ?? .timed },
//                    set: { assessmentSelection = $0 }
//                )
//            )
//            .navigationTransition(.zoom(sourceID: "zoom", in: namespace))
//        }
        
        // Configure Assessment Options
        .sheet(item: $assessmentSettingsSelection) { type in
            NavigationStack {
                AssessmentOptions(type: type)
            }
        }
        
        .sheet(isPresented: $showSettings) {
            NavigationStack {
                SettingsScreen()
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

struct GlassyPageScrubber: View {
    let count: Int
    @Binding var index: Int

    // Size tunables
    private let dotSize: CGFloat = 8
    private let dotSpacing: CGFloat = 10
    private let horizontalPadding: CGFloat = 28
    private let verticalPadding: CGFloat = 10

    var body: some View {
        GeometryReader { proxy in
            let fullWidth = proxy.size.width

            ZStack {
                glassBackground
                    .clipShape(Capsule())
                    .overlay(Capsule().stroke(.white.opacity(0.35), lineWidth: 1))
                    .shadow(color: .black.opacity(0.15), radius: 12, y: 6)

                HStack(spacing: dotSpacing) {
                    ForEach(0..<count, id: \.self) { i in
                        Circle()
                            .frame(width: dotSize, height: dotSize)
                            .foregroundStyle(i == index ? .white : .white.opacity(0.35))
                            .overlay(Circle().stroke(.white.opacity(i == index ? 0.8 : 0), lineWidth: 1))
                            .contentShape(Rectangle())
//                            .onTapGesture { index = i }
                    }
                }
                .padding(.horizontal, horizontalPadding)
                .padding(.vertical, verticalPadding)
            }
            // Scrub anywhere on the pill
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        let localX = min(max(value.location.x, 0), fullWidth)
                        let progress = clamp((localX - horizontalPadding) /
                                             max(1, (fullWidth - horizontalPadding * 2)), 0, 1)
                        let newIndex = Int(round(progress * CGFloat(count - 1)))
                        if newIndex != index { index = newIndex }
                    }
            )
        }
        .frame(height: 44)             // tall = “big” pill feel
        .padding(.horizontal, 60)      // overall width
    }

    // MARK: - Glass background that prefers the system “glass” effect
    @ViewBuilder
    private var glassBackground: some View {
        // Prefer the platform glass if available; fall back to a material.
        if #available(iOS 26.0, *) {
            // iOS 18+ (and future iOS 26+) supports the SwiftUI glass background.
            // This API name is stable in recent SDKs.
            Rectangle().fill(.clear)
                .glassEffect(in: Capsule())   // uses system glass rendering

        } else {
            // Back-compat
            Rectangle()
                .fill(.ultraThinMaterial)
        }
    }
}

// Small helper
@inline(__always)
private func clamp<T: Comparable>(_ v: T, _ a: T, _ b: T) -> T { min(max(v, a), b) }

