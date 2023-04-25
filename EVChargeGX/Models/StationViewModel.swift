//
//  stationViewModel.swift
//  EVChargeGX
//
//  Created by iosdev on 15.4.2023.
//

import Foundation
import CoreLocation

class stationViewModel: ObservableObject {
     
    @Published var stations = [StationData]()
    @Published var fetching = false
    
    @MainActor
    func fetchData() async {
        fetching = true
        
        await callApi(latitude: getUserLocation(manager: CLLocationManager())?.latitude ?? 0.0, longitude: getUserLocation(manager: CLLocationManager())?.longitude ?? 0.0 ) { result, error in
            if let error = error {
                print("Error decoding JSON: \(error)")
            } else if let result = result {
                // Do something with the array of objects here
                DispatchQueue.main.async { [weak self] in
                    self?.stations = result.map {
                        StationData(name: $0.AddressInfo.Title,
                                    address: $0.AddressInfo.AddressLine1,
                                    latitude: $0.AddressInfo.Latitude,
                                    longitude: $0.AddressInfo.Longitude)
                    }
                    self?.fetching = false
                }
            }
        }
    }
}
