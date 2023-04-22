//
//  ProfileView.swift
//  EVChargeGX
//
//  Created by iosdev on 4/14/23.
//

import SwiftUI

struct ProfileView: View {
    
    // Variables from UserDefaults
    @AppStorage("type2") var type2 = UserDefaults.standard.bool(forKey: "type2")
    @AppStorage("ccs") var ccs = UserDefaults.standard.bool(forKey: "ccs")
    @AppStorage("chademo") var chademo = UserDefaults.standard.bool(forKey: "chademo")
    @State private var firstManufacturer = UserDefaults.standard.string(forKey: "manufacturer")
    @State private var firstModel = UserDefaults.standard.string(forKey: "model")
    @State private var firstCapacity = UserDefaults.standard.string(forKey: "capacity")
    // Other variables
    @State private var manufacturer = ""
    @State private var manufacturerTitle = "No cars"
    @State private var model = ""
    @State private var capacity = ""
    @State private var addManufacturer = ""
    @State private var addModel = ""
    @State private var addCapacity = ""
    @State private var alert = false
    @State private var alertAddCar = false
    @State private var cars: [Car] = []
    @State private var carDelete: Car = Car(manufacturer: "", model: "", batteryCapacity: "")
    
    var body: some View {
        ZStack {
            Color(red: 205/255, green: 205/255, blue: 205/255)
                .ignoresSafeArea()
            VStack {
                VStack(alignment: .leading) {
                    Text("Profile")
                        .font(.system(size: 36, design: .default))
                        .padding(.bottom, -15.0)
                }.onAppear {
                    // Adds the first car's data to an Array and updates the text fields on profile page with the first car's data
                    if !(firstManufacturer ?? "").isEmpty && !(firstModel ?? "").isEmpty && !(firstCapacity ?? "").isEmpty {
                        let car1 = Car(manufacturer: firstManufacturer, model: firstModel, batteryCapacity: firstCapacity)
                        carDelete = car1
                        self.cars.append(car1)
                        updateInformation(newTitle: firstManufacturer ?? "No cars", newManufacturer: firstManufacturer ?? "", newModel: firstModel ?? "", newCapacity: firstCapacity ?? "")
                    }
                }
                List {
                    VStack() {
                        HStack {
                            Menu {
                                // Goes through the Car objects in the cars array and adds the objects to a picker
                                ForEach(cars) { car in
                                    Button("\(car.manufacturer ?? "")", action: {
                                        print("count: ", cars.count)
                                        // Adds the selected Car object's data to the variables that are used to show the selected car's data
                                        updateInformation(newTitle: car.manufacturer ?? "No cars", newManufacturer: car.manufacturer ?? "", newModel: car.model ?? "", newCapacity: car.batteryCapacity ?? "")
                                        carDelete = car
                                    })
                                }
                            } label: {
                                HStack {
                                    Text("Selected car: ")
                                        .foregroundColor(.black)
                                    Text("\(manufacturerTitle)")
                                    if !cars.isEmpty {
                                        Image(systemName: "arrow.down.app")
                                    }
                                }
                            }.id(UUID())
                            if !cars.isEmpty {
                                Button(action: {
                                    print(cars.count)
                                    if let index = cars.firstIndex(of: carDelete) {
                                        cars.remove(at: index)
                                    }
                                    if !cars.isEmpty {
                                        let carCount = cars.count - 1
                                        updateInformation(newTitle: cars[carCount].manufacturer ?? "No cars", newManufacturer: cars[carCount].manufacturer ?? "", newModel: cars[carCount].model ?? "", newCapacity: cars[carCount].batteryCapacity ?? "")
                                        carDelete = cars[carCount]
                                    } else {
                                        updateInformation(newTitle: "No cars", newManufacturer: "", newModel: "", newCapacity: "")
                                    }
                                }) {
                                    Image(systemName: "trash")
                                }.buttonStyle(BorderlessButtonStyle())
                            }
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Manufacturer: ")
                            Text("\(manufacturer)")
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
                            // Info buble that shows extra information about the connectors when tapped
                            Button(action: {
                                alert = true
                            }) {
                                Image(systemName: "info.circle")
                            }.alert(isPresented: $alert) {
                                Alert(
                                    title: Text("Your owned connector input is used to filter out stations with connectors you don't own.")
                                )
                            }
                        }
                        // Stops the button from being interacted in the whole HStack
                        .buttonStyle(BorderlessButtonStyle())
                        // Toggle buttons for connectors. Values stored in UserDefaults
                        VStack {
                            Toggle("Type 2", isOn: $type2)
                            Toggle("CCS", isOn: $ccs)
                            Toggle("CHAdeMO", isOn: $chademo)
                        }
                        .padding()
                        VStack {
                            // Button for adding a new Car object with the user's given values and adds it to the dropdown menu as selected and car information
                            Button(action: {
                                alertAddCar = true
                                updateInformation(newTitle: "", newManufacturer: "", newModel: "", newCapacity: "")
                            }) {
                                HStack {
                                    Text("Add a new car")
                                        .foregroundColor(.black)
                                }
                            }.alert("Add a new car", isPresented: $alertAddCar) {
                                TextField("Manufacturer", text: $addManufacturer)
                                TextField("Model", text: $addModel)
                                TextField("Battery capacity(kWh)", text: $addCapacity)
                                
                                Button("Cancel", action: {})
                                Button("Save", action: {
                                    // Creates a new Car object, adds it to the cars array
                                    let newCar = Car(manufacturer: addManufacturer, model: addModel, batteryCapacity: addCapacity)
                                    carDelete = newCar
                                    cars.append(newCar)
                                    // Updates the selected car's information and adds the new car to the dropdown menu as selected
                                    updateInformation(newTitle: addManufacturer, newManufacturer: addManufacturer, newModel: addModel, newCapacity: addCapacity)
                                })
                            }
                            .frame(width: 175, height: 50)
                            .background(.green)
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
    
    func updateInformation(newTitle: String, newManufacturer: String, newModel: String, newCapacity: String) {
        manufacturerTitle = newTitle
        manufacturer = newManufacturer
        model = newModel
        capacity = newCapacity
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
