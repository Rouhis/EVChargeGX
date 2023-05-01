//
//  stationModel.swift
//  EVChargeGX
//
//  Created by iosdev on 14.4.2023.
//
import Foundation


struct StationData: Identifiable {
    let id = UUID()
    var name: String
    var address: String
    var latitude: Double
    var longitude: Double
}

