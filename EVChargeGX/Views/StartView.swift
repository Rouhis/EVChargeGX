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
    @AppStorage("mapOpen") var mapOpen = false
    
    var body: some View {
        NavigationView {
            if firstTimeOpen {
                FirstView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            } else {
                MapView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
        }
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
