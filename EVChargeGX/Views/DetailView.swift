//
//  DetailView.swift
//  EVChargeGX
//
//  Created by iosdev on 21.4.2023.
//

import SwiftUI

import MapKit


struct StationDetailsView: View {
    //These values are passed from mapview to here
    let stationName: String
    let chargerType: String
    let chargerPower: Double
    let latitude: Double
    let longitude: Double
    @Binding var isPresented: Bool
    
    // Map region
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
    
    var body: some View {
        NavigationStack {
            VStack {
                Text(stationName)
                    .font(.title)
                    .padding()
                Divider()
                Text(chargerType + "\n" + String(format: "%0.1f", chargerPower) + " kW")
                    .padding()
                
                // Map view
                Map(coordinateRegion: $region, showsUserLocation: true , annotationItems: [StationAnnotation(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), title: stationName)]) { annotation in
                    MapMarker(coordinate: annotation.coordinate)
                }
                .frame(height: 300)
                //Button for opening maps
                Button(action: {
                    openMaps()
                }, label: {
                    Text("Open in Maps")
                        .padding()
                })
                Spacer()
                Button(action: {
                    isPresented = false
                }, label: {
                    Text("Close")
                        .padding()
                })
            }
        }
    }
    
    // Helper funciton to open maps
    private func openMaps() {
        let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let placemark = MKPlacemark(coordinate: coordinates)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = stationName
        mapItem.openInMaps(launchOptions: nil)
    }
}

// Custom annotation for the station
private struct StationAnnotation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let title: String
}


