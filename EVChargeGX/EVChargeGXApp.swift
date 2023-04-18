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
    @AppStorage("firstTimeOpen") var firstTimeOpen = true

    var body: some Scene {
        WindowGroup {
            // Conditional views. Not working because navigationview is on FirstView, so if ContentView is the first View navigation doesn't work
            /*if firstTimeOpen {
                FirstView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            } else {
                ContentView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }*/
            FirstView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
