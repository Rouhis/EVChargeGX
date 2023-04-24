//
//  Localization.swift
//  EVChargeGX
//
//  Created by iosdev on 22.4.2023.
//

import Foundation

class UserSettings: ObservableObject {
    @Published var lang: String = "en"

    var bundle: Bundle? {
        let b = Bundle.main.path(forResource: lang, ofType: "lproj")!
        return Bundle(path: b)
    }
}
