//
//  Car.swift
//  EVChargeGX
//
//  Created by iosdev on 4/16/23.
//

import Foundation

class Car: Identifiable, Equatable {
    static func == (lhs: Car, rhs: Car) -> Bool {
        lhs.manufacturer == rhs.manufacturer && lhs.model == rhs.model && lhs.batteryCapacity == rhs.batteryCapacity
    }
    
    var manufacturer: String?
    var model: String?
    var batteryCapacity: String?
    
    init(manufacturer: String?, model: String?, batteryCapacity: String?) {
        self.manufacturer = manufacturer
        self.model = model
        self.batteryCapacity = batteryCapacity
    }
    
    func deleteCar() {
        print("Car deleted")
        
    }
}
