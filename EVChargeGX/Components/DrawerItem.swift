//  drawerItem.swift
//  EVChargeGX
//
//  Created by iosdev on 13.4.2023.
//
import SwiftUI

struct drawerItem: View {
    
    @State var stationName: String
    @State var stationAddress: String
    
    var body: some View {
        NavigationLink(destination: PopUpView(stationName: stationName, stationAddress: stationAddress), label: {
            HStack {
                VStack(alignment: .leading) {
                    Text("\(String(stationName))")
                        .font(.headline)
                    Text("\(String(stationAddress))")
                        .font(.headline)
                }.padding(.leading, 10)
                
                Spacer()
            }
        })
    }
}


