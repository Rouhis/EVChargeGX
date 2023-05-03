//
//  ApiModel.swift
//  EvChargeGX
//
//  Created by iosdev on 16.4.2023.
//
//This is the model for the API so we get only the data we want from the API
import Foundation

struct Base:Codable{
    let AddressInfo: Info
    let Connections : [Connections]
}
struct Info:Codable{
    let Title: String
    let AddressLine1: String
    let Latitude: Double
    let Longitude: Double
}

struct Connections:Codable {
    let ConnectionType: ConnectionType?
    let PowerKW: Double?
}

struct ConnectionType:Codable {
    let Title:String?
}

