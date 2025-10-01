//
//  Email Coordinator.swift
//  Diadochokinetic Assess
//
//  Created by Collin on 12/19/19.
//  Copyright © 2019 Ballygorey Apps. All rights reserved.
//

import Foundation
import MessageUI
import SwiftUI
import UIKit

struct MailView: UIViewControllerRepresentable {

    @Environment(\.presentationMode) var presentation
    @Binding var result: Result<MFMailComposeResult, Error>?

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {

        @Binding var presentation: PresentationMode
        @Binding var result: Result<MFMailComposeResult, Error>?

        init(
            presentation: Binding<PresentationMode>,
            result: Binding<Result<MFMailComposeResult, Error>?>
        ) {
            _presentation = presentation
            _result = result
        }

        func mailComposeController(
            _ controller: MFMailComposeViewController,
            didFinishWith result: MFMailComposeResult,
            error: Error?
        ) {
            defer {
                $presentation.wrappedValue.dismiss()
            }
            guard error == nil else {
                self.result = .failure(error!)
                return
            }
            self.result = .success(result)
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(
            presentation: presentation,
            result: $result)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.setToRecipients(["apps@ballygorey.com"])
        vc.setSubject("DDK Feedback")  // #\(UUID())")
        vc.mailComposeDelegate = context.coordinator
        vc.setMessageBody("Dear DDK Developer,\n[\(Bundle.appVersionWithBuild)]", isHTML: false)
        return vc
    }

    func updateUIViewController(
        _ uiViewController: MFMailComposeViewController,
        context: UIViewControllerRepresentableContext<MailView>
    ) {

    }
}
