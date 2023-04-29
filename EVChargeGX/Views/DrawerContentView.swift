//
//  drawerContentView.swift
//  EVChargeGX
//
//  Created by iosdev on 12.4.2023.
//
import SwiftUI

struct StationsListView: View {
    var items: [AnnotationItem]

    var body: some View {
        VStack {
            if items.isEmpty {
                Text("No stations found")
            } else {
                List(items) { annotationItem in
                    drawerItem(stationName: annotationItem.title,/* stationAddress: annotationItem.address,*/ chargerType: annotationItem.Connections.first?.ConnectionType?.Title ?? "",
                               chargerPower: annotationItem.Connections.first?.PowerKW ?? 0,
                               stationLatitude: annotationItem.coordinate.latitude,
                               stationLongitude: annotationItem.coordinate.longitude)
                    
                }
                .listStyle(.plain)
                .padding(-5)
            }
        }
    }
}


