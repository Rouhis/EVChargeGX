//
//  StartView.swift
//  EVChargeGX
//
//  Created by iosdev on 4/21/23.
//

import SwiftUI

struct StartView: View {
    
    let persistenceController = PersistenceController.shared
    @AppStorage("firstTimeOpen") var firstTimeOpen = true
    
    var body: some View {
        NavigationView {
            if firstTimeOpen {
                FirstView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            } else {
                ContentView()
                    .environment(\.locale, .init(identifier: "fi"))
            }
        }
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
