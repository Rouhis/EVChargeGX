//
//  ProfileView.swift
//  EVChargeGX
//
//  Created by iosdev on 4/14/23.
//

import SwiftUI

struct ProfileView: View {
    // Access managed object context with this variable to save data to CoreData
    @Environment(\.managedObjectContext) var moc
    
    // Gets the data that's in the CoreData's Car object as an array
    @FetchRequest(sortDescriptors: []) var cars: FetchedResults<Car>
    
    // Variables from UserDefaults
    @AppStorage("type2") var type2 = UserDefaults.standard.bool(forKey: "type2")
    @AppStorage("ccs") var ccs = UserDefaults.standard.bool(forKey: "ccs")
    @AppStorage("chademo") var chademo = UserDefaults.standard.bool(forKey: "chademo")
    @AppStorage("firstTimeOpen") var firstTimeOpen = UserDefaults.standard.bool(forKey: "firstTimeOpen")
    @State private var firstManufacturer = UserDefaults.standard.string(forKey: "firstManufacturer")
    @State private var firstModel = UserDefaults.standard.string(forKey: "firstModel")
    @State private var firstCapacity = UserDefaults.standard.string(forKey: "firstCapacity")
    
    // New variables to UserDefaults
    @AppStorage("manufacturer") var manufacturer = ""
    @AppStorage("manufacturerTitle") var manufacturerTitle = ""
    @AppStorage("model") var model = ""
    @AppStorage("capacity") var capacity = ""
    
    @State private var addManufacturer = ""
    @State private var addModel = ""
    @State private var addCapacity = ""
    @State private var alert = false
    @State private var alertAddCar = false
    
    // Variable for storing a Car object for deleting
    @State private var carDelete: Car = Car()
    
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
                    let carsCount = cars.count - 1
                    // Creates a new Car object to the CoreData using the data from FirstView, if there are no Car objects previously created.
                    if cars.isEmpty {
                        if !(firstManufacturer ?? "").isEmpty && !(firstModel ?? "").isEmpty && !(firstCapacity ?? "").isEmpty {
                            updateInformation(newTitle: firstManufacturer ?? "", newManufacturer: firstManufacturer ?? "", newModel: firstModel ?? "", newCapacity: firstCapacity ?? "")
                            let car1 = Car(context: moc)
                            car1.manufacturer = manufacturer
                            car1.model = model
                            car1.batteryCapacity = capacity
                            
                            try? moc.save()
                            
                            // Assign the first Car object to the carDelete variable
                            carDelete = car1
                        }
                    } else {
                        // If there already is a Car object in the CoreData use the previously used Car. Data gotten from UserDefaults
                        updateInformation(newTitle: manufacturer, newManufacturer: manufacturer, newModel: model, newCapacity: capacity)
                        // Use the findCar function so the delete car button works on first click
                        findCar(manufacturer: manufacturer, model: model, capacity: capacity)
                    }
                }
                List {
                    VStack {
                        HStack {
                            Menu {
                                // Go through all of the Car objects in the fetchrequest result array
                                ForEach(cars) { car in
                                    // add all of the Cars into the dropdown menu
                                    Button("\(car.manufacturer ?? "")") {
                                        // Whenever a Car is selected from the menu, set that Car's information to variables to use them in the profile page
                                        updateInformation(
                                            newTitle: car.manufacturer ?? "",
                                            newManufacturer: car.manufacturer ?? "",
                                            newModel: car.model ?? "",
                                            newCapacity: car.batteryCapacity ?? ""
                                        )
                                        // Assign selected Car to the delete variable
                                        carDelete = car
                                    }
                                }
                            } label: {
                                HStack {
                                    Text("Selected car:")
                                        .foregroundColor(.secondary)
                                    // Conditional statements to add icons when there are Cars
                                    if manufacturerTitle.isEmpty {
                                        Text("No cars")
                                            .foregroundColor(.secondary)
                                    } else {
                                        Text("\(manufacturerTitle)")
                                            .foregroundColor(.primary)
                                    }
                                    if !cars.isEmpty {
                                        Image(systemName: "arrowtriangle.down.fill")
                                            .foregroundColor(.primary)
                                    }
                                }
                                // .id(UUID()) is required so that the dropdown menu works properly when clicked
                            }.id(UUID())
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                            
                            // Delete button for when there are Cars in the CoreData
                            if !cars.isEmpty {
                                Button(action: {
                                    // Upon pressing the delete icon, delete the selected Car from CoreData
                                    moc.delete(carDelete)
                                    // Save the changes that occured in CoreData
                                    try? moc.save()
                                    // if there are still Cars left after deleting, select the next Car and update the selected vehicle information
                                    if !cars.isEmpty {
                                        let carCount = cars.count - 1
                                        updateInformation(
                                            newTitle: cars[carCount].manufacturer ?? "",
                                            newManufacturer: cars[carCount].manufacturer ?? "",
                                            newModel: cars[carCount].model ?? "",
                                            newCapacity: cars[carCount].batteryCapacity ?? ""
                                        )
                                        // Assign the next Car after deletion to the delete variable
                                        carDelete = cars[carCount]
                                    } else {
                                        // Update profile information to nothing if there are no more Cars left
                                        updateInformation(newTitle: "", newManufacturer: "", newModel: "", newCapacity: "")
                                    }
                                }) {
                                    Image(systemName: "trash.fill")
                                        .foregroundColor(.red)
                                }
                                .buttonStyle(BorderlessButtonStyle())
                                .padding(.leading, 10)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            // Selected vehicle information
                            HStack {
                                Text("Manufacturer:")
                                    .foregroundColor(.secondary)
                                Text("\(manufacturer)")
                            }
                            HStack {
                                Text("Model:")
                                    .foregroundColor(.secondary)
                                Text("\(model)")
                            }
                            HStack {
                                Text("Battery capacity(kWh):")
                                    .foregroundColor(.secondary)
                                Text("\(capacity)")
                                
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 10)
                    }
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
                            // Button for adding a new Car object with the user's given values and adds it to the dropdown menu as selected and vehicle information
                            Button(action: {
                                alertAddCar = true
                                addManufacturer = ""
                                addModel = ""
                                addCapacity = ""
                            }) {
                                HStack {
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundColor(.green)
                                    Text("Add a new car")
                                        .foregroundColor(.black)
                                }
                            }
                            .frame(maxWidth: .infinity, minHeight: 50)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .padding()
                            .alert("Add a new car", isPresented: $alertAddCar) {
                                TextField("Manufacturer", text: $addManufacturer)
                                TextField("Model", text: $addModel)
                                TextField("Battery capacity (kWh)", text: $addCapacity).keyboardType(.numberPad)
                                
                                Button("Cancel", role: .cancel) {}
                                Button("Save", role: .destructive) {
                                    // Creates a new Car object and saves it to the CoreData
                                    let newCar = Car(context: moc)
                                    newCar.manufacturer = addManufacturer
                                    newCar.model = addModel
                                    newCar.batteryCapacity = addCapacity
                                    
                                    try? moc.save()
                                    carDelete = newCar
                                    // Updates the selected car's information and adds the new car to the dropdown menu as selected
                                    updateInformation(newTitle: addManufacturer, newManufacturer: addManufacturer, newModel: addModel, newCapacity: addCapacity)
                                }
                            }
                            
                        }
                        // Stops the button from being interacted in the whole HStack
                        .buttonStyle(BorderlessButtonStyle())
                        .padding()
                    }
                }
                .scrollContentBackground(.hidden)
                .listRowSeparator(.hidden)
            }
        }
    }
    
    // Update the selected vehicle information with the given values
    func updateInformation(newTitle: String, newManufacturer: String, newModel: String, newCapacity: String) {
        manufacturerTitle = newTitle
        manufacturer = newManufacturer
        model = newModel
        capacity = newCapacity
    }
    
    // Go through each Car in the CoreData fetchrequest and assign the last selected Car to the delete variable
    // Necessary so that the delete Car button works on first press
    func findCar(manufacturer: String, model: String, capacity: String) {
        for car in cars {
            if car.manufacturer == manufacturer && car.model == model && car.batteryCapacity == capacity {
                carDelete = car
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
