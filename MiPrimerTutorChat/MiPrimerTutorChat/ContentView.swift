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

struct AButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity)
            .background(.green)
            .foregroundStyle(.white)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct BButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity)
            .background(.yellow)
            .foregroundStyle(.white)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct CButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity)
            .background(.red)
            .foregroundStyle(.white)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct DButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity)
            .background(.purple)
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
                    Text("Mi Primer Tutor")
                        .font(.system(size: 36, weight: .heavy, design: .rounded))
                        .multilineTextAlignment(.center)
                        .padding()
                }
                Image(.logo)
                    .resizable()
                    .scaledToFit()
                    .imageScale(.large)
                    .cornerRadius(10)
                    .padding()
                    .foregroundStyle(.blue)
                
                NavigationLink("Profesor", destination: MenuProfesorView())
                    .font(.largeTitle)
                    .tint(.blue)
                    .padding()
                    .buttonStyle(GrowingButton())
                    
                
                NavigationLink("Padres", destination: MenuPadresView()) // MainMessagesView()
                    .font(.largeTitle)
                    .tint(.blue)
                    .padding()
                    .buttonStyle(GrowingButton())
                
                NavigationLink("Alumno", destination: LoginAlumnoView()) // LoginView(didCompleteLoginProcess: {})
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
