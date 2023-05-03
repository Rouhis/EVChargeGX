//
//  DetailView.swift
//  EVChargeGX
//
//  Created by iosdev on 21.4.2023.
//
import UIKit
import SwiftUI

import MapKit

//This is the sheet that is shown when annotation or draweritem is clicked
struct StationDetailsView: View {
    //These values are passed from mapview to here
    let stationName: String = UserDefaults.standard.string(forKey: "stationName") ?? ""
    let chargerType: String = UserDefaults.standard.string(forKey: "chargerType") ?? ""
    let chargerPower: Double = UserDefaults.standard.double(forKey: "chargerPower")
    let latitude: Double
    let longitude: Double
    let stationAddress: String = UserDefaults.standard.string(forKey: "stationAddress") ?? ""
    
    @State private var carBattery = UserDefaults.standard.string(forKey: "capacity")
    
    // These are used to calculate the time it takes to charge your EV
    @State private var hours: Double = 0.0
    @State private var totalMinutes = 0
    @State private var hoursString = ""
    @State private var minutesString = ""
    @State private var timeString = ""
    @Binding var region: MKCoordinateRegion
    @Binding var isPresented: Bool
    
    // Map region
    
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
                        HStack {
                            Text("Charging from 0 to 100% takes")
                            Text("\(timeString)")
                        }
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
                
            }.onAppear {
                //Calculations for the charge time
                if carBattery == nil {
                    carBattery = UserDefaults.standard.string(forKey: "firstCapacity")
                }
                hours = (Double(carBattery ?? "") ?? 0.0 ) / chargerPower
                totalMinutes = Int(hours * 60.0)
                hoursString = "\(totalMinutes / 60)h"
                minutesString = String(format: "%02dm", totalMinutes % 60)
                timeString = "\(hoursString) \(minutesString)"
                print(":D", timeString)
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
    // This is a private function that opens the Maps app and displays a location based on its latitude, longitude, and name.
    private func openMaps() {
        
        // Create a CLLocationCoordinate2D object using the latitude and longitude values.
        let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        // Create an MKPlacemark object using the coordinates.
        let placemark = MKPlacemark(coordinate: coordinates)
        
        // Create an MKMapItem object using the placemark and set its name to the station name.
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = stationName
        
        // Launch the Maps app with the specified location.
        mapItem.openInMaps(launchOptions: nil)
    }

}

// Custom annotation for the station
private struct StationAnnotation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let title: String
}

