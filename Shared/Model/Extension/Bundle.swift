//
//  Bundle.swift
//  Diadochokinetic Assess
//
//  Created by Collin Dunphy on 10/1/25.
//

import Foundation

extension Bundle {
    /// App version (e.g. "1.2.3")
    static let appVersion: String = {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    }()

    /// App build number (e.g. "45")
    static let appBuild: String = {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"
    }()

    /// Combined app version + build (e.g. "1.2.3 (45)")
    static let appVersionWithBuild: String = {
        if appBuild == "Unknown" {
            return appVersion
        }
        return "\(appVersion) (\(appBuild))"
    }()
}
