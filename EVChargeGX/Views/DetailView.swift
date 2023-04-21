//
//  DetailView.swift
//  EVChargeGX
//
//  Created by iosdev on 21.4.2023.
//

import SwiftUI

struct StationDetailsView: View {
    let stationName: String
    let chargerType: String
    let chargerPower: Double
    @Binding var isPresented: Bool

    var body: some View {
        NavigationStack{
            VStack {
                NavigationLink(destination: ProfileView()) {
                    Text("Go to Profile")
                }
                Text(stationName)
                    .font(.title)
                    .padding()
                Divider()
                Text(chargerType + "\n" + String(format: "%0.1f", chargerPower) + " kW")
                    .padding()
                Spacer()
                Button(action: {
                    isPresented = false
                }, label: {
                    Text("Close")
                        .padding()
                })
                
                
            }
        }
    }
}

