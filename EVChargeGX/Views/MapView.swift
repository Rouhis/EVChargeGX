//  ContentView.swift
//  EVChargeGX
//
//  Created by iosdev on 3.4.2023.
//
import MapKit
import SwiftUI
import Drawer

struct AnnotationItem: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let title: String
    let address: String
    let Connections : [Connections]
}

public func getUserLocation(manager: CLLocationManager) -> CLLocationCoordinate2D? {
     guard let userLocation = manager.location?.coordinate else {
         return nil
     }
     print("test \(userLocation)")
     return userLocation
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
    @State private var stationName: String = ""
    @State private var chargerType: String = ""
    @State private var chargerPower: Double = 0
    @State private var sheetIsPresented = false
    @State private var stationLatitude: Double = 0
    @State private var stationLongitude: Double = 0
    
    @State private var speechTranscript = ""
    @State var heights = [CGFloat(110),CGFloat(600)]


    @AppStorage("type2") var type2 = UserDefaults.standard.bool(forKey: "type2")
    @AppStorage("ccs") var ccs = UserDefaults.standard.bool(forKey: "ccs")
    @AppStorage("chademo") var chademo = UserDefaults.standard.bool(forKey: "chademo")
    @AppStorage("filterByStations") var filterByStations = false
    @AppStorage("filterByConnectors") var filterByConnectors = false
    
    struct TextFielButton: ViewModifier{
        @State private var alert = false
        @StateObject var speechRecognizer = SpeechRecognizer()
        @State private var isRecording = false
        @Binding var serText: String
        @Binding var speechTranscript: String
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
                            self.speechTranscript = speechRecognizer.transcript
                            print(speechRecognizer.transcript)
                            
                        })
                        
                    }
                }
            }
        }
    }
    
    var body: some View {
        NavigationStack{
            ZStack {
                TextField("Search", text: $searchQuery, onCommit: search).modifier(TextFielButton(serText: $searchQuery, speechTranscript: $speechTranscript)).onChange(of: speechTranscript){ newValue in
                    searchQuery = newValue
                    search()}
                .padding()
                .background(Color(.systemGray5))
                .cornerRadius(10)
                .padding(.horizontal)
                .padding(.bottom, 600)
                .zIndex(1)
                
                Button(action: {
                    if let userLocation = getUserLocation(manager: locationManager) {
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
                            stationLatitude = annotation.coordinate.latitude
                            stationLongitude = annotation.coordinate.longitude
                            
                            sheetIsPresented = true
                        }
                        .sheet(isPresented: $sheetIsPresented) {
                            StationDetailsView(stationName: stationName, chargerType: chargerType, chargerPower: chargerPower,latitude: stationLatitude,longitude: stationLongitude, isPresented: $sheetIsPresented)
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
                                    let test = item.Connections[0].ConnectionType?.Title ?? ""
                                    if !test.isEmpty && filterByConnectors {
                                        print(":DDD", test, type2, ccs, chademo)
                                        if type2 && test.contains("Type 2") {
                                            print(":lll", "Type 2 toimii", type2)
                                            annotationItems.append(annotationItem)
                                        } else if ccs && test.contains("CCS") {
                                            print(":lll", "ccs toimii", ccs)
                                            annotationItems.append(annotationItem)
                                        } else if chademo && test.contains("CHAdeMO") {
                                            print(":lll","chademo toimii", chademo)
                                            annotationItems.append(annotationItem)
                                        } else {
                                            print(":ppp", "No stations with connectors")
                                        }
                                    } else {
                                        annotationItems.append(annotationItem)
                                    }
                                    print(item.AddressInfo.Title)
                                }
                            }
                        }
                    }
                }
                
            }.toolbar{
                Menu {
                    NavigationLink(destination: ProfileView(), label: {
                        Text("Profile")
                        Image(systemName: "person.circle")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.blue)
                        
                    })
                    Toggle(isOn: $filterByConnectors) {
                        Text("Filter by owned connectors")
                    }
                } label: {
                    Image(systemName: "line.horizontal.3")
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
                                let test = item.Connections[0].ConnectionType?.Title ?? ""
                                if !test.isEmpty && filterByConnectors {
                                    print(":DDD", test, type2, ccs, chademo)
                                    if type2 && test.contains("Type 2") {
                                        print(":lll", "Type 2 toimii", type2)
                                        annotationItems.append(annotationItem)
                                    } else if ccs && test.contains("CCS") {
                                        print(":lll", "ccs toimii", ccs)
                                        annotationItems.append(annotationItem)
                                    } else if chademo && test.contains("CHAdeMO") {
                                        print(":lll","chademo toimii", chademo)
                                        annotationItems.append(annotationItem)
                                    } else {
                                        print(":ppp", "No stations with connectors")
                                    }
                                } else {
                                    annotationItems.append(annotationItem)
                                }
                                print(item.AddressInfo.Title)
                                
                            }
                        }
                    }
                }
            }
            
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
                                title: item.AddressInfo.Title, address: item.AddressInfo.AddressLine1,
                                Connections: item.Connections
                            )

                            annotationItems.append(annotationItem)
                            print(item.AddressInfo.Title)
                        }
                    }
                }
            }
        }
            //////////////////////////////////////////////////////////////////////////////////////////////////////
           
            Drawer(heights: $heights) {
                
                ZStack{
                    Color(.systemBackground)
                    VStack{
                        RoundedRectangle(cornerRadius: 20).frame(width: 60, height: 5, alignment: .center)
                            .background(Color.white)
                            .padding(10)
                        
                        //AnnotationsListView(items: annotationItems)
                        
                        StationsListView(items: annotationItems)
                        Spacer()
                    }
                }
            }.edgesIgnoringSafeArea(.vertical).zIndex(2)
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
                                title: item.AddressInfo.Title, address: item.AddressInfo.AddressLine1,
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
    let query = searchQuery.isEmpty ? speechTranscript : searchQuery

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


