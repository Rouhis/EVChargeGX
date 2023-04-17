//
//  ProfileView.swift
//  EVChargeGX
//
//  Created by iosdev on 4/14/23.
//

import SwiftUI

struct ProfileView: View {
    
    @AppStorage("type2") var type2 = UserDefaults.standard.bool(forKey: "type2")
    @AppStorage("ccs") var ccs = UserDefaults.standard.bool(forKey: "ccs")
    @AppStorage("chademo") var chademo = UserDefaults.standard.bool(forKey: "chademo")
    @State private var firstManufacturer = UserDefaults.standard.string(forKey: "manufacturer")
    @State private var firstModel = UserDefaults.standard.string(forKey: "model")
    @State private var firstCapacity = UserDefaults.standard.string(forKey: "capacity")
    @State private var manufacturer = ""
    @State private var manufacturerTitle = "No cars"
    @State private var model = ""
    @State private var capacity = ""
    @State private var alert = false
    @State private var cars: [Car] = []
    
    var body: some View {
        let car1 = Car(manufacturer: firstManufacturer, model: firstModel, batteryCapacity: firstCapacity)
        ZStack {
            Color(red: 205/255, green: 205/255, blue: 205/255)
                .ignoresSafeArea()
            VStack {
                VStack(alignment: .leading) {
                    Text("Profile")
                        .font(.system(size: 36, design: .default))
                        .padding(.bottom, -15.0)
                }.onAppear {
                    self.cars.append(car1)
                    manufacturer = firstManufacturer ?? ""
                    model = firstModel ?? ""
                    capacity = firstCapacity ?? ""
                    manufacturerTitle = firstManufacturer ?? "No cars"
                }
                List {
                    VStack() {
                        Menu {
                            ForEach(cars) { car in
                                Button("\(car.manufacturer ?? "")", action: {
                                    manufacturerTitle = car.manufacturer ?? "No cars"
                                    manufacturer = car.manufacturer ?? ""
                                    model = car.model ?? ""
                                    capacity = car.batteryCapacity ?? ""
                                })
                            }
                        } label: {
                            HStack {
                                Text("Selected car: ")
                                    .foregroundColor(.black)
                                    Text("\(manufacturerTitle)")
                                Image(systemName: "arrow.down.app")
                            }
                        }
                        /*Picker("Choose a car", selection: $test)
                        {
                            ForEach(cars) { car in
                                Text(car.manufacturer ?? "")
                            }
                        }
                        .pickerStyle(MenuPickerStyle())*/
                        
                        VStack(alignment: .leading) {
                            Text("Manufacturer: \(manufacturer)")
                                .padding(.bottom, 5)
                            Text("Model: \(model)")
                                .padding(.bottom, 5)
                            Text("Battery capacity(kWh): \(capacity)")
                        }
                        .padding()
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .listRowSeparator(.hidden)
                    
                    VStack {
                        HStack {
                            Text("Owned connectors")
                            Button(action: {                                alert = true}) {
                                Image(systemName: "info.circle")
                            }.alert(isPresented: $alert) {
                                Alert(
                                    title: Text("Your owned connector input is used to filter out stations with connectors you don't own.")
                                )
                            }
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        VStack {
                            Toggle("Type 2", isOn: $type2)
                            Toggle("CCS", isOn: $ccs)
                            Toggle("CHAdeMO", isOn: $chademo)
                        }
                        .padding()
                        VStack {
                            Button(action: {print(cars)}) {
                                HStack {
                                    Text("Add a new car")
                                        .foregroundColor(.black)
                                    Image(systemName: "plus.circle")
                                }
                            }
                            .frame(width: 175, height: 50)
                            .background(.green)
                            Button(action: {}) {
                                Text("Delete selected car")
                                    .foregroundColor(.black)
                            }
                            .frame(width: 175, height: 50)
                            .background(.red)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        .padding()
                    }
                }
                .scrollContentBackground(.hidden)
                .listRowSeparator(.hidden)
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
