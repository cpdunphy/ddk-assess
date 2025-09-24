//
//  Settings.swift
//  Diadochokinetic Assess
//
//  Created by Collin Dunphy on 9/29/20.
//

import StoreKit
import SwiftUI

#if os(iOS)
    import MessageUI
#endif

struct SettingsScreen: View {
    @EnvironmentObject var store: Store

    #if os(iOS)
        @State private var mailResult: Result<MFMailComposeResult, Error>? = nil
        @State private var showingMailView: Bool = false
    #endif

    // MARK: - Form
    var form: some View {
        List {

            // App Information + More
            Section("Information") {

                NavigationLink(destination: AboutDDK()) {
                    SettingsScreenButton(
                        title: "About",
                        symbolSystemName: "info.circle.fill",
                        symbolColor: .white
                    )
                    .symbolRenderingMode(.palette)
                }

                NavigationLink(destination: Statistics()) {
                    SettingsScreenButton(
                        title: "Statistics",
                        symbolSystemName: "sum",
                        symbolColor: .orange
                    )
                }
            }

            Section {
                rateApp
                callSupport
                privacyPolicy
                termsOfService
            }

            if !store.supportProductOptions.isEmpty {
                Section {
                    NavigationLink(destination: SupportDevelopment()) {
                        Label(
                            title: {
                                Text("Support the Developer")
                                    .foregroundColor(.primary)
                            },
                            icon: {
                                Image(systemName: "takeoutbag.and.cup.and.straw.fill")
                                    .font(.title3)
                                    .symbolRenderingMode(.palette)
                                    .foregroundStyle(.yellow, .red)
                            }
                        )

                    }
                }
            }

            Section {
                ResetAllPreferences()
            }
        }

    }

    // MARK: - Body
    var body: some View {
        form
            .navigationTitle("Settings")

            // Mail Popover Sheet
            #if os(iOS)
                .sheet(isPresented: $showingMailView) {
                    MailView(result: $mailResult)
                }
            #endif
    }

    var callSupport: some View {
        #if os(iOS)
            Button {
                #if os(iOS)
                    showingMailView.toggle()
                #else
                    if let url = U {
                        UIApplication.shared.open(url)
                    }
                #endif
            } label: {
                SettingsScreenButton(
                    title: "Feedback / Support",
                    symbolSystemName: "questionmark.diamond.fill"
                )
                .symbolRenderingMode(.multicolor)
            }.disabled(!MFMailComposeViewController.canSendMail())
        #else
            Link(
                destination: URL(string: "mailto:apps@ballygorey.com?subject=Subject&body=Test")!,
                label: {
                    SettingsScreenButton(
                        title: "Support / Feedback",
                        symbolSystemName: "questionmark.diamond.fill"
                    )
                    .symbolRenderingMode(.multicolor)
                }
            )
        #endif
    }

    var termsOfService: some View {
        Link(destination: URL(string: "https://ddk.ballygorey.com/legal/terms")!) {
            SettingsScreenButton(
                title: "Terms of Service",
                symbolSystemName: "doc.append.fill",
                symbolColor: .teal
            )
        }
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
    }

    var rateApp: some View {
        #if os(iOS)
            Button(
                action: {
                    if let scene = UIApplication.shared.connectedScenes.first(
                        where: { $0.activationState == .foregroundActive })
                        as? UIWindowScene
                    {
                        SKStoreReviewController.requestReview(in: scene)
                    } else {
                        if let url = URL(
                            string: "itms-apps://itunes.apple.com/app/id\(1_489_873_060)?action=write-review&mt=8"
                        ) {
                            UIApplication.shared.open(url)
                        }
                    }

                }
            ) {
                SettingsScreenButton(
                    title: "Do you love DDK?",
                    symbolSystemName: "suit.heart.fill",
                    symbolColor: .pink
                )
            }
        #else
            Link(
                destination: URL(
                    string: "itms-apps://itunes.apple.com/app/id\(1_489_873_060)?action=write-review&mt=8"
                )!,
                label: {
                    SettingsScreenButton(
                        title: "Do you love DDK?",
                        symbolSystemName: "suit.heart.fill",
                        symbolColor: .pink
                    )
                }
            )
        #endif
    }

    // Button that resets the preferences across the whole app.
    struct ResetAllPreferences: View {

        @State private var showResetConfirmationAlert: Bool = false

        var body: some View {
            // Reset Preferences
            Section {
                Button {
                    showResetConfirmationAlert = true
                } label: {
                    Label(
                        "Reset All Preferences",
                        systemImage: "exclamationmark.arrow.circlepath"
                    )
                }.foregroundColor(.red)
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

        @EnvironmentObject var timed: TimedAssessment
        @EnvironmentObject var count: CountingAssessment
        @EnvironmentObject var hr: HeartRateAssessment

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
