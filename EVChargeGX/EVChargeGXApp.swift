//
//  EVChargeGXApp.swift
//  EVChargeGX
//
//  Created by iosdev on 3.4.2023.
//
import SwiftUI

@main
struct EVChargeGXApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
            WindowGroup {
                StartView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
        }
    
}
