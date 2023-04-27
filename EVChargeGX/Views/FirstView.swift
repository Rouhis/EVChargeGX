//
//  FirstView.swift
//  EVChargeGX
//
//  Created by iosdev on 4/3/23.
//

import SwiftUI
import CoreLocation

struct FirstView: View {
    @State private var locationManager = CLLocationManager()
    
    // variables stored in Appstorage
    @AppStorage("firstManufacturer") var manufacturer = ""
    @AppStorage("firstModel") var model = ""
    @AppStorage("firstCapacity") var capacity = ""
    @AppStorage("type2") var type2 = false
    @AppStorage("ccs") var ccs = false
    @AppStorage("chademo") var chademo = false
    @AppStorage("firstTimeOpen") var firstTimeOpen = UserDefaults.standard.bool(forKey: "firstTimeOpen")
    @State private var alert = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    
                    Text("Welcome!")
                        .font(.title)
                        .fontWeight(.semibold)
                        .padding()
                    
                    Text("Please give us information about your electric vehicle")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    Form {
                        Section(header: Text("Vehicle information")) {
                            TextField("Manufacturer", text: $manufacturer)
                            TextField("Model", text: $model)
                            TextField("Battery capacity (kWh)", text: $capacity)
                        }
                        
                        Section(header: Text("Preferred/Owned connector types")) {
                            Toggle("Type 2", isOn: $type2)
                            Toggle("CCS", isOn: $ccs)
                            Toggle("CHAdeMO", isOn: $chademo)
                        }
                    }
                    .onTapGesture {
                        hideKeyboard()
                    }
                    .listStyle(.insetGrouped)
                    .accentColor(.blue)
                    
                    Spacer()
                    
                    VStack {
                        NavigationLink(
                            destination: ContentView(),
                            label: {
                                Text("Done")
                                    .frame(maxWidth: .infinity, minHeight: 44)
                                    .background(Color(.systemGreen))
                                    .foregroundColor(.white)
                                    .font(.headline)
                                    .cornerRadius(10)
                            }).simultaneousGesture(TapGesture().onEnded{
                                print("Saved")
                                firstTimeOpen = false
                            })
                        .padding(.horizontal)
                        
                        Button(action: {
                            firstTimeOpen = false
                            manufacturer = ""
                            model = ""
                            capacity = ""
                        }, label: {
                            Text("I will do this later")
                                .font(.headline)
                                .underline()
                                .foregroundColor(.blue)
                        })
                        .padding(.vertical)
                        
                        Button(action: {
                            alert = true
                        }, label: {
                            Image(systemName: "info.circle")
                                .foregroundColor(.blue)
                        })
                        .alert(isPresented: $alert) {
                            Alert(
                                title: Text("You can skip this part, but vehicle information won't be saved")
                            )
                        }
                    }
                    .padding(.bottom)
                }
                .padding()
                .onAppear {
                    locationManager.requestWhenInUseAuthorization()
                }
            }
        }
    }}
struct FirstView_Previews: PreviewProvider {
    static var previews: some View {
        FirstView()
    }
}

// Extension with a function to hide the keyboard
#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
