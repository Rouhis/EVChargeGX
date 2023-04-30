//  drawerItem.swift
//  EVChargeGX
//
//  Created by iosdev on 13.4.2023.
//
import MapKit
import SwiftUI

struct drawerItem: View {
    
    @AppStorage("stationName") var stationName: String = ""
    //@State var stationAddress: String
    @AppStorage("chargerType") var chargerType: String = ""
    @AppStorage("chargerPower") var chargerPower: Double = 0
    @State var sheetIsPresented = false
    @State var stationLatitude: Double
    @State var stationLongitude: Double
    @AppStorage("stationAddress") var stationAddress: String = ""
    @State private var stationRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0.0, longitude: 24.688388),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(String(stationName))")
                    .font(.headline)
                Text("\(String(stationAddress))")
                   .font(.headline)
            }.padding(.leading, 10)
            
            Spacer()
        }
        //This makes the entire box clickable not just the text
        .contentShape(Rectangle())
        .onTapGesture{
            stationRegion = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: stationLatitude, longitude: stationLongitude),
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
            sheetIsPresented = true
        }
        .sheet(isPresented: $sheetIsPresented) {
            StationDetailsView(latitude: stationLatitude,longitude: stationLongitude, region: $stationRegion, isPresented: $sheetIsPresented)
        }
    }
}
