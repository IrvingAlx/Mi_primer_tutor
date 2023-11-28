//
//  LoginAlumnoView.swift
//  MiPrimerTutorChat
//
//  Created by Irving Alejandro Vega Lagunas on 26/11/23.
//

import SwiftUI

struct LoginAlumnoView: View {
    @State private var username = ""
    @State private var password = ""
    
    var body: some View {
        VStack{
            Text("Bienvenido")
                .font(.system(size: 36, weight: .heavy, design: .rounded))
                .multilineTextAlignment(.center)
                .padding(50)
                
            Image(systemName: "ladybug.fill")
                .resizable()
                .scaledToFit()
                .imageScale(.large)
                .cornerRadius(10)
                .padding()
                .foregroundStyle(.blue)
                
            HStack{
                TextField("Usuario", text: $username)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            }
            .padding(20)
            HStack{
                SecureField("Contraseña", text: $password)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            }
            .padding(20)
                
            Text("")
                .font(.title)
            
            /*Button("Aceptar") {
                
            }*/
            NavigationLink("Aceptar", destination: MenuAlumnoView())
                .font(.largeTitle)
                .tint(.blue)
                .padding()
                .buttonStyle(GrowingButton())
                        
            /*if navigateToIngresarNipView {
                NavigationLink("", destination: IngresarNipView(numeroTarjeta: noTarjeta), isActive: $navigateToIngresarNipView)
                .opacity(0)
            }*/
        }
    }
}

#Preview {
    LoginAlumnoView()
}
