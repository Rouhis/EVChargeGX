//
//  ApiModel.swift
//  EvChargeGX
//
//  Created by iosdev on 16.4.2023.
//

import Foundation

struct Base:Codable{
    let AddressInfo: Info
}
struct Info:Codable{
    let Title: String
    let AddressLine1: String
    let Latitude: Double
    let Longitude: Double
}
