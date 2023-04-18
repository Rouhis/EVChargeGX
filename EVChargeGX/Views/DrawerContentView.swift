//
//  drawerContentView.swift
//  EVChargeGX
//
//  Created by iosdev on 12.4.2023.
//
import SwiftUI


extension StationData {

}



struct StationsListView: View {
    @StateObject fileprivate var viewModel = stationViewModel()
    var body: some  View {
        VStack{
            List(viewModel.stations){StationData in
                drawerItem(stationName: StationData.name, stationAddress: StationData.address)
                
                
            }.listStyle(.plain).padding(-5)
            
                .task{
                    await viewModel.fetchData()
                }
            
            
        }
    }
}


