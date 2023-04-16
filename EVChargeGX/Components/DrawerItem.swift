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
        HStack{
            Circle()
                .frame(width: 50, height: 50)
                .foregroundColor(Color.white)
                .padding(.leading, 25)
                .padding(.trailing, 15)
            VStack{
                Text("\(String(stationName))")
                Text("\(String(stationAddress))")
            }
            Spacer()
        }
    }
}
