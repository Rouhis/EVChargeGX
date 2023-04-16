//
//  FirstView.swift
//  EVChargeGX
//
//  Created by iosdev on 4/3/23.
//

import SwiftUI
import MapKit
struct FirstView: View {
    
    // variables stored in Appstorage
    @AppStorage("manufacturer") var manufacturer = ""
    @AppStorage("model") var model = ""
    @AppStorage("capacity") var capacity = ""
    @AppStorage("type2") var type2 = false
    @AppStorage("ccs") var ccs = false
    @AppStorage("chademo") var chademo = false
    @AppStorage("firstTimeOpen") var firstTimeOpen = true
    @State private var alert = false
    var body: some View {
        NavigationView{
            ZStack {
                Color(red: 205/255, green: 205/255, blue: 205/255)
                    .ignoresSafeArea()
                // Add a keyboard image as a button to dismiss keyboard
                    .toolbar {
                        Button {
                            hideKeyboard()
                        } label: {
                            Image(systemName: "keyboard.chevron.compact.down")
                        }
                    }
                VStack {
                    VStack {
                        Text("Welcome to EVChargeGX!")
                            .bold()
                            .italic()
                            .padding()
                            .font(.system(size: 36, design: .default))
                    }
                    VStack {
                        Text("Please give us information about your electric vehicle")
                            .font(.system(size: 24, design: .default))
                            .padding(.horizontal, 30)
                            .italic()
                            .multilineTextAlignment(.center)
                    }
                    // Form for vehicle information and preferred connector types for filterting charging stations
                    Form {
                        Section(header: Text("Vehicle information") .foregroundColor(.black)) {
                            TextField("Manufacturer", text: $manufacturer)
                            TextField("Model", text: $model)
                            TextField("Battery capacity(kWh)", text: $capacity)
                        }
                        Section(header: Text("Preferred/Owned connector types") .foregroundColor(.black)) {
                            Toggle("Type 2", isOn: $type2)
                            Toggle("CCS", isOn: $ccs)
                            Toggle("CHAdeMO", isOn: $chademo)
                        }
                    }
                    // Hide keyboard when tapping on a form element
                    .onTapGesture {
                        hideKeyboard()
                    }
                    // Hide the form's default colour(white). Only works on IOS 16 and above
                    .scrollContentBackground(.hidden)
                    //.background(Color(red: 205/255, green: 205/255, blue: 205/255))
                    Spacer()
                    // Buttons for navigating. Also adds a gesture to perform an action like a button.
                    VStack {
                        NavigationLink(destination: ContentView(), label: {
                            Text("Done")
                                .italic()
                                .frame(width: 100, height: 55)
                                .background(Color(red: 193/255, green: 250/255, blue: 193/255))
                                .cornerRadius(15)
                                .foregroundColor(.black)
                        }
                        ).simultaneousGesture(TapGesture().onEnded{
                            print("Saved")
                            firstTimeOpen = false
                        })
                        HStack {
                            NavigationLink(destination: ProfileView(), label:{                            Text("I will do this later")
                                    .foregroundColor(.black)
                                    .underline()
                                    .italic()
                                    .font(.system(size: 17, design: .default))
                                    .offset(x: 12)
                            }).simultaneousGesture(TapGesture().onEnded{
                                print("Later")
                                firstTimeOpen = false
                            })
                            .padding(.vertical)
                            // Create an information button outside the navigation link. When clicked display additional information as alert
                            Button(action: {                                alert = true}) {
                                Image(systemName: "info.circle").foregroundColor(.blue)
                            }.offset(x: 10, y: 1)
                                .alert(isPresented: $alert) {
                                    Alert(
                                        title: Text("You can skip this part and the already made changes will be saved.")
                                    )
                                }
                        }
                    }
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
