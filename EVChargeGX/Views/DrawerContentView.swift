//
//  drawerContentView.swift
//  EVChargeGX
//
//  Created by iosdev on 12.4.2023.
//
import SwiftUI




extension AnnotationItem{
    
}


struct StationsListView: View {
    var items: [AnnotationItem]
    var body: some View {
        VStack {
            if items.isEmpty {
                Text("No stations found")
            } else {
                List(items) { annotationItem in
                    drawerItem(stationName: annotationItem.title, stationAddress: annotationItem.address)
                }
                .listStyle(.plain)
                .padding(-5)
            }
        }
    }
}


