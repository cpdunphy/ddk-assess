//
//  Settings.swift
//  Diadochokinetic Assess
//
//  Created by Collin Dunphy on 9/29/20.
//

import MessageUI
import StoreKit
import SwiftUI

struct SettingsScreen: View {

    @State private var mailResult: Result<MFMailComposeResult, Error>?
    @State private var showingMailView: Bool = false

    var body: some View {
        List {
            // App Information + More
            Section {
                NavigationLink(destination: AboutScreen()) {
                    Label("About", systemImage: "info.circle.fill")
                }

                NavigationLink(destination: Statistics()) {
                    Label("Statistics", systemImage: "sum")
                        .labelStyle(.iconTint(.orange))
                }
                .buttonStyle(.plain)
            }

            Section {
                rateApp
                support
                privacyPolicy
                termsOfService
            }

            Section {
                ResetAllPreferences()
            }
        }
        .navigationTitle("Settings")

        // Mail Popover Sheet
        .sheet(isPresented: $showingMailView) {
            MailView(result: $mailResult)
        }
    }

    var support: some View {
        let label = Label("Feedback / Support", systemImage: "questionmark.diamond.fill")
            .symbolRenderingMode(.multicolor)

        return Group {
            if MFMailComposeViewController.canSendMail() {
                Button {
                    showingMailView.toggle()
                } label: {
                    label
                }
                .buttonStyle(.plain)
            } else {
                Link(destination: URL(string: "mailto:apps@ballygorey.com?subject=Feedback%20for%20DDK")!) {
                    label
                }
                .buttonStyle(.plain)
            }
        }
    }

    var termsOfService: some View {
        Link(destination: URL(string: "https://ddk.ballygorey.com/legal/terms")!) {
            Label("Terms of Service", systemImage: "doc.append.fill")
                .labelStyle(.iconTint(.teal))
        }
        .buttonStyle(.plain)
    }

    var privacyPolicy: some View {
        Link(destination: URL(string: "https://ddk.ballygorey.com/legal/privacy")!) {
            Label(
                title: {
                    Text("Privacy Policy")
                        .foregroundColor(.primary)
                },
                icon: {
                    Image(systemName: "lock.shield.fill")
                        .font(.title3)
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.yellow, .cyan)
                }
            )
        }
        .buttonStyle(.plain)
    }

    var rateApp: some View {
        Button {
            let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive })
            if let scene = scene as? UIWindowScene {
                AppStore.requestReview(in: scene)
            } else {
                if let url = URL(
                    string: "itms-apps://itunes.apple.com/app/id\(1_489_873_060)?action=write-review&mt=8"
                ) {
                    UIApplication.shared.open(url)
                }
            }
        } label: {
            Label("Do you love DDK?", systemImage: "suit.heart.fill")
                .labelStyle(.iconTint(.pink))
        }
        .buttonStyle(.plain)
    }

    // Button that resets the preferences across the whole app.
    struct ResetAllPreferences: View {

        @EnvironmentObject var timed: TimedAssessment
        @EnvironmentObject var count: CountingAssessment
        @EnvironmentObject var hr: HeartRateAssessment

        @State private var showResetConfirmationAlert: Bool = false

        var body: some View {
            // Reset Preferences
            Section {
                Button(role: .destructive) {
                    showResetConfirmationAlert = true
                } label: {
                    Label(
                        "Reset All Preferences",
                        systemImage: "exclamationmark.arrow.circlepath"
                    )
                }
                .foregroundColor(.red)
            }

            // Reset Settings Confirmation
            .alert(
                "Reset Preferences",
                isPresented: $showResetConfirmationAlert,
                actions: {
                    Button("Cancel", role: .cancel) {}

                    Button(
                        "Reset",
                        role: .destructive,
                        action: resetPreferences
                    )
                },
                message: {
                    Text("Are you sure you want to reset ALL preferences?")
                }
            )
        }

        func resetPreferences() {
            timed.resetPreferences()
            count.resetPreferences()
            hr.resetPreferences()
        }
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreen()
    }
}
