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
    let Connections : [Connections]
}

struct MapView: View {
    fileprivate let locationManager: CLLocationManager = CLLocationManager()
    private var regionDebouncer = Debouncer(delay: 0.5)
    @State private var searchQuery = ""
    @State private var selectedAnnotation: AnnotationItem?
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 60.173767, longitude: 24.688388),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    @State private var alert = false
    @State private var annotationItems = [AnnotationItem]()
    @State private var stationName = ""
    @State private var chargerType = ""
    @State private var chargerPower: Double = 0
    @State private var sheetIsPresented = false
    
    
    struct TextFielButton: ViewModifier{
        @State private var alert = false
        @StateObject var speechRecognizer = SpeechRecognizer()
        @State private var isRecording = false
        @Binding var serText: String
        public func body(content: Content) -> some View {
            ZStack(alignment: .trailing){
                content
                if !serText.isEmpty{
                    Button(action: {
                        self.serText = ""
                    }){
                        Image(systemName: "delete.left").foregroundColor(Color(UIColor.opaqueSeparator))
                    }
                } else{
                    Button(action: {
                        alert = true
                        speechRecognizer.resetTranscript()
                        speechRecognizer.startTranscribing()
                        isRecording = true
                    }){Image(systemName: "mic.circle").foregroundColor(Color(UIColor.opaqueSeparator))
                    }.alert(isPresented: $alert){
                        Alert(title: Text("Recording started"),
                              message: Text("Press 'End' to end recording"),
                              dismissButton: .default(Text("End")){
                            speechRecognizer.stopTranscribing()
                            isRecording = false
                            alert = false
                            self.serText = speechRecognizer.transcript
                            print(speechRecognizer.transcript)
                        })
                        
                    }
                }
            }
        }
    }
    
    var body: some View {
        ZStack {
            TextField("Search", text: $searchQuery, onCommit: search).modifier(TextFielButton(serText: $searchQuery))
                .padding()
                .background(Color(.systemGray5))
                .cornerRadius(10)
                .padding(.horizontal)
                .padding(.bottom, 600)
                .zIndex(1)
            
            Button(action: {
                if let userLocation = locationManager.location?.coordinate {
                    region = MKCoordinateRegion(center: userLocation, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
                }
            }, label: {
                Image(systemName: "location.fill")
                    .padding()
                    .background(Color.white)
                    .clipShape(Circle())
            })
            .padding(.top, 500.0)
            .padding(.leading, 300)
            .frame(width: nil)
            .zIndex(1)
            
            
            Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: annotationItems)
            { annotation in
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
                        stationName = annotation.title
                        chargerType = annotation.Connections.first?.ConnectionType?.Title ?? ""
                        chargerPower = annotation.Connections.first?.PowerKW ?? 0
                        sheetIsPresented = true
                    }
                    .sheet(isPresented: $sheetIsPresented) {
                        DetailView()
                    }
                .onDisappear {
                    annotationItems.removeAll()
                }
            }
            //This onChange is responsible for changes on the map
        }.onChange(of: region.center.latitude) { _ in
            // Remove old annotations
            annotationItems.removeAll()
            
            // Debounce the API call by 0.5 seconds
            regionDebouncer.debounce {
                // Call the API with the new region coordinates
                callApi(latitude: region.center.latitude, longitude: region.center.longitude) { result, error in
                    if let error = error {
                        print("Error decoding JSON: \(error)")
                    } else if let result = result {
                        // Add new annotations
                        for item in result{
                            let annotationItem = AnnotationItem(
                                coordinate: CLLocationCoordinate2D(latitude: item.AddressInfo.Latitude, longitude: item.AddressInfo.Longitude),
                                title: item.AddressInfo.Title,
                                Connections: item.Connections
                            )
                            annotationItems.append(annotationItem)
                            print(item.AddressInfo.Title)
                        }
                    }
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
                        for (_, item) in result.enumerated() {
                            let annotationItem = AnnotationItem(
                                coordinate: CLLocationCoordinate2D(latitude: item.AddressInfo.Latitude, longitude: item.AddressInfo.Longitude),
                                title: item.AddressInfo.Title,
                                Connections: item.Connections
                            )
                            annotationItems.append(annotationItem)
                            print(item.AddressInfo.Title)
                            
                        }
                    }
                }
            }
        }
    
}
//Search function for the searchbar
func search() {
    // Create a CLGeocoder instance to geocode the search query
    let geocoder = CLGeocoder()
    
    // Use the geocoder to look up the coordinates of the search query
    geocoder.geocodeAddressString(searchQuery) { placemarks, error in
        if let error = error {
            // If there is an error, print it to the console
            print("Error geocoding search query: \(error.localizedDescription)")
        } else if let placemark = placemarks?.first {
            // If the geocoding was successful, get the coordinates of the first placemark
            let coordinate = placemark.location?.coordinate
            print("Coordinates of \(searchQuery): \(coordinate?.latitude ?? 0), \(coordinate?.longitude ?? 0)")
            
            // Change the region to be centered on the search query coordinates
            region = MKCoordinateRegion(center: coordinate!, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        }
    }
    
}
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}

