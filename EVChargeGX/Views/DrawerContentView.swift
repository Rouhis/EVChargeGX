//
//  drawerContentView.swift
//  EVChargeGX
//
//  Created by iosdev on 12.4.2023.
//
import SwiftUI
//This is the view for the drawer
struct StationsListView: View {
    //this takes the annotation items from mapview
    var items: [AnnotationItem]

    var body: some View {
        VStack {
            if items.isEmpty {
                Text("No stations found")
            } else {
                //Make a list of the items and pass many parameters to the draweritem view
                List(items) { annotationItem in
                    drawerItem(stationName: annotationItem.title, chargerType: annotationItem.Connections.first?.ConnectionType?.Title ?? "",
                               chargerPower: annotationItem.Connections.first?.PowerKW ?? 0,
                               stationLatitude: annotationItem.coordinate.latitude,
                               stationLongitude: annotationItem.coordinate.longitude,
                               stationAddress: annotationItem.address
                    )
                    
                }
                .listStyle(.plain)
                .padding(-5)
            }
        }
    }
}


