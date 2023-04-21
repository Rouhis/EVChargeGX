//
//  PopUpView.swift
//  EVChargeGX
//
//  Created by iosdev on 16.4.2023.
//
import SwiftUI

struct PopUpView: View {
    
    @State var stationName: String
    @State var stationAddress: String
    
    var body: some View {
        Text(stationName)
    }
}
