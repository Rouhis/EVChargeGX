//
//  ContentView.swift
//  EVChargeGX
//
//  Created by iosdev on 3.4.2023.
//
import SwiftUI
import CoreData
import Drawer

struct ContentView: View {
    @State private var isShowingStations = false
    @State var heights = [CGFloat(110),CGFloat(750)]
 //   @State var station = Base(AddressInfo: Info)
    
    
    var body: some View{
        
            ZStack{
                    MapView()
                
                Drawer(heights: $heights) {
                    ZStack{
                        Color(uiColor: UIColor.secondarySystemBackground)
                        VStack{
                            RoundedRectangle(cornerRadius: 20).frame(width: 60, height: 5, alignment: .center)
                                .background(Color.white)
                                .padding(10)
                            StationsListView()
                            Spacer()
                        }
                    }
                }.edgesIgnoringSafeArea(.vertical)
            }
            
                .toolbar{
                    NavigationLink(destination: ProfileView(), label: {
                        Text("Profile")
                    }).simultaneousGesture(TapGesture().onEnded{
                   //     print("hmomo petteri\($station)")
               
                    })
                }
        }
    }




struct SettingsView: View {
    
    var color: Color
    
    var body: some View{
        CircleNumberView(color: color, number: 1)
            .navigationTitle("Settings")
            Text("Test")
                .toolbar{
                    Button("test"){
                    }
                    
                }
    }
}

struct CircleNumberView: View{
    
    var color: Color
    var number: Int


    
    var body: some View {
        ZStack{
            Circle()
                .frame(width: 200, height: 200)
                .foregroundColor(color)
            Text("\(number)")
                .foregroundColor(.white)
                .font(.system(size: 70, weight: .bold))
            

        }
    }
}


private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()
