//
//  DetailView.swift
//  EVChargeGX
//
//  Created by iosdev on 21.4.2023.
//
import UIKit
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
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                
                Divider()
                
                HStack {
                    VStack(alignment: .leading) {
                        
                        Text(chargerType)
                            .font(.title3)
                            .fontWeight(.bold)
                        
                        Text(String(format: "%.1f kW", chargerPower))
                            .font(.subheadline)
                    }
                    
                    Spacer()
                }
                .padding()
                
                // Map view
                Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: [StationAnnotation(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), title: stationName)]) { annotation in
                    MapMarker(coordinate: annotation.coordinate)
                }
                .frame(height: 300)
                .cornerRadius(10)
                .padding()
                
                Button(action: {
                    openMaps()
                }, label: {
                    Text("Open in Maps")
                        .fontWeight(.semibold)
                        .padding()
                        .foregroundColor(.white)
                })
                .background(Color.blue)
                .cornerRadius(10)
                .padding()
                
                Spacer()
                
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button(action: {
                isPresented = false
            }, label: {
                Image(systemName: "xmark.circle")
                    .font(.title)
            }))
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

struct DetailView: View {
    var body: some View{
       Text(":D")
    }
   
}

