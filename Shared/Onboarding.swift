//
//  Onboarding.swift
//  Diadochokinetic Assess (macOS)
//
//  Created by Collin Dunphy on 3/10/22.
//

import SwiftUI

struct Onboarding: View {
    var body: some View {
        #if os(macOS)
        OnboardingMac()
        #else
        OnboardingMobile()
        #endif
    }
}

struct Onboarding_Previews: PreviewProvider {
    static var previews: some View {
        Onboarding()
    }
}
