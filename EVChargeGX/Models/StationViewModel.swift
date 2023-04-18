//
//  stationViewModel.swift
//  EVChargeGX
//
//  Created by iosdev on 15.4.2023.
//

import Foundation

 class stationViewModel: ObservableObject {
    @Published var stations = [StationData]()
    @Published var fetching = false
    
     @MainActor
    func fetchData() async {
        fetching = true
        
        await callApi(latitude: 37.785834, longitude: -122.406417){
            result, error in
            if let error = error {
                print("Error decoding JSON: \(error)")
            } else if let result = result {
                // Do something with the array of objects here
                for item in result {
                    self.stations.append(StationData(name: item.AddressInfo.Title, address: item.AddressInfo.AddressLine1, latitude: item.AddressInfo.Latitude, longitude: item.AddressInfo.Longitude))
                    
                }
            }
            
        }
        
        
        fetching = false
    }
}
