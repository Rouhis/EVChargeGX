//
//  Car.swift
//  EVChargeGX
//
//  Created by iosdev on 4/16/23.
//

import Foundation

class Car: Identifiable {
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
