//
//  EVChargeGXApp.swift
//  EVChargeGX
//
//  Created by iosdev on 16.4.2023.
//

import SwiftUI

@main
struct EVChargeGXApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
