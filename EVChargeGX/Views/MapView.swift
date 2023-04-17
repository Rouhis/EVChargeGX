//  ContentView.swift
//  EVChargeGX
//
//  Created by iosdev on 3.4.2023.
//
import MapKit
import SwiftUI

struct AnnotationItem: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let title: String
}

struct MapView: View {
    fileprivate let locationManager: CLLocationManager = CLLocationManager()
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 60.173767, longitude: 24.688388),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    @State private var annotationItems = [AnnotationItem]()
    
    var body: some View {
        ZStack {
                Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: annotationItems) { annotation in
                    MapAnnotation(coordinate: annotation.coordinate) {
                        VStack {
                            Image(systemName: "bolt.fill")
                                .resizable()
                                .foregroundColor(.white)
                                .frame(width: 20, height: 30)
                                .background(
                                    Circle()
                                        .fill(Color.blue)
                                        .frame(width: 30, height: 30)
                                )
                            Circle()
                                .fill(Color.red)
                                .frame(width: 8, height: 8)
                        }
                        .frame(width: 60, height: 60)
                        .cornerRadius(10)
                        .shadow(radius: 3)
                        .onTapGesture {
                            print(annotation.title)
                        }
                        
                    }
                }
            
            
        }

            .edgesIgnoringSafeArea(.all)
            .onAppear {
                
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.distanceFilter = kCLDistanceFilterNone
                locationManager.startUpdatingLocation()
                if let userLocation = locationManager.location?.coordinate {
                    region = MKCoordinateRegion(center: userLocation, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
                    
                    callApi(latitude: userLocation.latitude, longitude: userLocation.longitude) { result, error in
                        if let error = error {
                            print("Error decoding JSON: \(error)")
                        } else if let result = result {
                            // Do something with the array of objects here
                            for item in result {
                                let annotationItem = AnnotationItem(
                                    coordinate: CLLocationCoordinate2D(latitude: item.AddressInfo.Latitude, longitude: item.AddressInfo.Longitude),
                                    title: item.AddressInfo.Title
                                )
                                annotationItems.append(annotationItem)
                                print(item.AddressInfo.Title)
                            }
                        }
                    }
                }
            }
        }
    }
    struct MapView_Previews: PreviewProvider {
        static var previews: some View {
            MapView()
        }
    }
