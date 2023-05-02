//  EVChargeGX
//
//  Created by iosdev on 3.4.2023.
//
import MapKit
import SwiftUI
import Drawer

/*The base used to make items for diffrent views*/
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
    @State private var stationRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0.0, longitude: 24.688388),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    @State private var alert = false
    @State private var annotationItems = [AnnotationItem]()
    @AppStorage("stationName") var stationName: String = ""
    @AppStorage("chargerType") var chargerType: String = ""
    @AppStorage("chargerPower") var chargerPower: Double = 0
    @State private var sheetIsPresented = false
    @State private var stationLatitude: Double = 0
    @State private var stationLongitude: Double = 0
    @AppStorage("stationAddress") var stationAddress: String = ""
    
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
                    }){Image(systemName: "mic.circle").foregroundColor(Color(UIColor.black))
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
                //Text field for seaches
                TextField("Search", text: $searchQuery, onCommit: search).modifier(TextFielButton(serText: $searchQuery, speechTranscript: $speechTranscript)).onChange(of: speechTranscript){ newValue in
                    searchQuery = newValue
                    search()}
                .padding()
                .background(Color(.systemGray5))
                .cornerRadius(10)
                .padding(.horizontal)
                .padding(.bottom, 600)
                .zIndex(1)
                
                //Button to center on users location
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
                            //Here when the annotation is clicked we set values for the sheet
                            stationName = annotation.title
                            chargerType = annotation.Connections.first?.ConnectionType?.Title ?? ""
                            chargerPower = annotation.Connections.first?.PowerKW ?? 0
                            stationLatitude = annotation.coordinate.latitude
                            stationLongitude = annotation.coordinate.longitude
                            stationAddress = annotation.address
                            stationRegion = MKCoordinateRegion(
                                center: CLLocationCoordinate2D(latitude: stationLatitude, longitude: stationLongitude),
                                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                            )
                            
                            sheetIsPresented = true
                        }
                        .sheet(isPresented: $sheetIsPresented) {
                            //Here we pass the values we just set to the sheet
                            StationDetailsView(latitude: stationLatitude,longitude: stationLongitude, region: $stationRegion, isPresented: $sheetIsPresented)
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
                                        address: item.AddressInfo.AddressLine1,
                                        Connections: item.Connections
                                        
                                    )
                                    // Get the connector's title inside connections from the station object
                                    // Return an empty string if there is no information about the connector title
                                    if !item.Connections.isEmpty {
                                        let test = item.Connections[0].ConnectionType?.Title ?? ""
                                        // Check that the connector title is not empty and that the user has toggled on the filter by connectors in MapView
                                        // If so, check what connectors the user owns and if the nearby stations use those connectos
                                        // If the stations use owned connectors display only those stations on the map. If user owns none of the connectors and the filter option is on, no stations are displayed on the map
                                        if !test.isEmpty && filterByConnectors {
                                            if type2 && test.contains("Type 2") {
                                                annotationItems.append(annotationItem)
                                            } else if ccs && test.contains("CCS") {
                                                annotationItems.append(annotationItem)
                                            } else if chademo && test.contains("CHAdeMO") {
                                                annotationItems.append(annotationItem)
                                            }
                                            // If the filter is turned off or there were no connector titles in any of the station objects show every station near the user regardless of connector type
                                        } else {
                                            annotationItems.append(annotationItem)
                                        }
                                    } else {
                                        annotationItems.append(annotationItem)
                                    }
                                }
                            }
                        }
                    }
                }
    
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
                }.toolbar{
                    //Menu
                    Menu {
                        NavigationLink(destination: ProfileView(), label: {
                            Text("Profile")
                            Image(systemName: "person.circle")

                            
                        })
                        Toggle(isOn: $filterByConnectors) {
                            Text("Filter by owned connectors")
                            Image(systemName: "eraser")
        
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)

                    }
                }
                .edgesIgnoringSafeArea(.vertical).zIndex(2)
            }
            .edgesIgnoringSafeArea(.all)
        }
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
                                    address: item.AddressInfo.AddressLine1,
                                    Connections: item.Connections
                                )
                                // Same code that's on the .onChange function
                                let test = item.Connections[0].ConnectionType?.Title ?? ""
                                if !test.isEmpty && filterByConnectors {
                                    if type2 && test.contains("Type 2") {
                                        annotationItems.append(annotationItem)
                                    } else if ccs && test.contains("CCS") {
                                        annotationItems.append(annotationItem)
                                    } else if chademo && test.contains("CHAdeMO") {
                                        annotationItems.append(annotationItem)
                                    }
                                } else {
                                    annotationItems.append(annotationItem)
                                }
                                
                            }
                    }
                }
            }
        }
    
}
//Search function for the searchbar
func search() {
    _ = searchQuery.isEmpty ? speechTranscript : searchQuery

    // Create a CLGeocoder instance to geocode the search query
    let geocoder = CLGeocoder()
    
    // Use the geocoder to look up the coordinates of the search query
    geocoder.geocodeAddressString(searchQuery) { placemarks, error in
        if let error = error {
            // If there is an error, print it to the console
            print("Error geocoding search query: \(error.localizedDescription)")
        } else if let placemark = placemarks?.first {
            // If the geocoding was successful, get the coordinates of the placemark
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


