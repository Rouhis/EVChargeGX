//  drawerItem.swift
//  EVChargeGX
//
//  Created by iosdev on 13.4.2023.
//
import SwiftUI

struct drawerItem: View {
    
    @State var stationName: String
    @State var stationAddress: String
    @State var chargerType: String
    @State var chargerPower: Double
    @State var sheetIsPresented = false
    @State var stationLatitude: Double
    @State var stationLongitude: Double

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
            sheetIsPresented = true
        }
        .sheet(isPresented: $sheetIsPresented) {
            StationDetailsView(stationName: stationName, chargerType: chargerType, chargerPower: chargerPower,latitude: stationLatitude,longitude: stationLongitude, isPresented: $sheetIsPresented)
        }
    }
}
