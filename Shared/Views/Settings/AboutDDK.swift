//
//  AboutDDK.swift
//  AboutDDK
//
//  Created by Collin Dunphy on 7/23/21.
//

import SwiftUI
import StoreKit

struct AboutDDK: View {
    var body: some View {
        ScrollView {
            VStack {
                Text("DDK")
                    .font(.system(size: 100, weight: .regular, design: .rounded))
                Text("Version \(getAppCurrentVersionNumber())".capitalized)
                    .font(.system(.body, design: .rounded))
                    .foregroundColor(.secondary)
            }.padding(.bottom, 32)
            
            Text("Made with ❤️.")
        }
        .navigationTitle("About")
    }
    
    func getAppCurrentVersionNumber() -> String {
        let dictionary = Bundle.main.infoDictionary!
        let version: AnyObject? = dictionary["CFBundleShortVersionString"] as AnyObject?
        let build : AnyObject? = dictionary["CFBundleVersion"] as AnyObject?
        let versionStr = version as! String
        let buildStr = build as! String
        return "\(versionStr) (\(buildStr))"
    }
    
    func versionDescription() -> String {
        return "\(getAppCurrentVersionNumber())"
    }
}

struct AboutDDK_Previews: PreviewProvider {
    static var previews: some View {
        AboutDDK()
    }
}
