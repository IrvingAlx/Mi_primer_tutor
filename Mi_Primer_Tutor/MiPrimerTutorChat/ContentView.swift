//
//  ContentView.swift
//  MiPrimerTutorChat
//
//  Created by Irving Alejandro Vega Lagunas on 20/11/23.
//

import SwiftUI

struct GrowingButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity)
            .background(.blue)
            .foregroundStyle(.white)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct ContentView: View {
    var body: some View {
        NavigationView{
            VStack {
                HStack{
                    /*Image(systemName: "bitcoinsign.circle")
                        .resizable()
                        .frame(width: 56.0, height: 56.0)
                        .imageScale(.large)
                        .foregroundStyle(.blue)
                        .padding()*/
                    Text("Mi Primer Tutor")
                        .font(.system(size: 36, weight: .heavy, design: .rounded))
                        .multilineTextAlignment(.center)
                        .padding()
                    /*Image(systemName: "bitcoinsign.circle")
                        .resizable()
                        .frame(width: 56.0, height: 56.0)
                        .imageScale(.large)
                        .foregroundStyle(.blue)
                        .padding()*/
                }
                Image(systemName: "graduationcap.fill")
                    .resizable()
                    .scaledToFit()
                    .imageScale(.large)
                    .cornerRadius(10)
                    .padding()
                    .foregroundStyle(.blue)
                
                NavigationLink("Profesor", destination: LoginView(didCompleteLoginProcess: {}))
                    .font(.largeTitle)
                    .tint(.blue)
                    .padding()
                    .buttonStyle(GrowingButton())
                    
                
                NavigationLink("Padres", destination: MainMessagesView())
                    .font(.largeTitle)
                    .tint(.blue)
                    .padding()
                    .buttonStyle(GrowingButton())
                
                NavigationLink("Alumno", destination: LoginView(didCompleteLoginProcess: {}))
                    .font(.largeTitle)
                    .tint(.blue)
                    .padding()
                    .buttonStyle(GrowingButton())
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    ContentView()
}
