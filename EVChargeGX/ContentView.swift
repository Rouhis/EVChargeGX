//
//  ContentView.swift
//  EVChargeGX
//
//  Created by iosdev on 3.4.2023.
//
import SwiftUI
import CoreData
import Drawer
import AVFoundation


struct ContentView: View {
    @State private var isShowingStations = false
    @State var heights = [CGFloat(110),CGFloat(750)]
  //  @State private var transcript = ""
    @State private var isRecording = false
    @State private var alert = false
    
    @StateObject var speechRecognizer = SpeechRecognizer()
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
                            Button("record"){
                                speechRecognizer.resetTranscript()
                                speechRecognizer.startTranscribing()
                                isRecording = true
                                alert = true
                            }.alert(isPresented: $alert){
                                Alert(title: Text("Recording started"),
                                    message: Text("Press 'End' to end recording"),
                                      dismissButton: .default(Text("End")){
                                    speechRecognizer.stopTranscribing()
                                    isRecording = false
                                    alert = false
                                    print(speechRecognizer.transcript)
                                })
                                
                            }
                          /*  Button("End Record"){
                                speechRecognizer.stopTranscribing()
                                isRecording = false
                                alert = false
                                print(speechRecognizer.transcript)
                                
                                
                            }*/
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
                    })
                }
        }
    func startRecord(){
        speechRecognizer.resetTranscript()
        speechRecognizer.startTranscribing()
            isRecording = true
    }

    func endRecord(){
        speechRecognizer.stopTranscribing()
        isRecording = false
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
