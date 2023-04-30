//  drawerItem.swift
//  EVChargeGX
//
//  Created by iosdev on 13.4.2023.
//
import MapKit
import SwiftUI

struct drawerItem: View {
    
    @State var stationName: String
    //@State var stationAddress: String
    @State var chargerType: String
    @State var chargerPower: Double
    @State var sheetIsPresented = false
    @State var stationLatitude: Double
    @State var stationLongitude: Double
    @State var stationAddress: String
    @State private var stationRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0.0, longitude: 24.688388),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    @AppStorage("stationName") var station = (UserDefaults.standard.string(forKey: "stationName") ?? "")
    @AppStorage("chargerType") var charger = (UserDefaults.standard.string(forKey: "chargerType") ?? "")
    @AppStorage("chargerPower") var power = UserDefaults.standard.double(forKey: "chargerPower")
    @AppStorage("stationAddress") var address = (UserDefaults.standard.string(forKey: "stationAddress") ?? "")

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
            station = stationName
            charger = chargerType
            power = chargerPower
            address = stationAddress
            sheetIsPresented = true
        }
        .sheet(isPresented: $sheetIsPresented) {
            StationDetailsView(latitude: stationLatitude,longitude: stationLongitude, region: $stationRegion, isPresented: $sheetIsPresented)
        }
    }
}
