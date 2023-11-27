//
//  AltaAlumunoView.swift
//  MiPrimerTutorChat
//
//  Created by Irving Alejandro Vega Lagunas on 26/11/23.
//

import SwiftUI

struct AltaAlumunoView: View {
    
    @State private var sexoSeleccionado = 0

    let opciones = ["Hombre","Mujer"]
    
    var body: some View {
        VStack{
            Text("Alta Alumno")
                .font(.system(size: 36, weight: .heavy, design: .rounded))
                .multilineTextAlignment(.center)
                .padding(20)
            Image(systemName: "person")
                .resizable()
                .scaledToFit()
                .imageScale(.large)
                .cornerRadius(10)
                .frame(width: 150)
                .padding(20)
            HStack{
                Text("Nombres: ")
                    .font(.title2)
                TextField("Nombre", text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
                    .font(.title2)
            }
            .frame(width: 360)
            .padding(20)
            HStack{
                Text("Apellido Paterno: ")
                    .font(.title2)
                TextField("Apellidos", text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
                    .font(.title2)
            }
            .frame(width: 360)
            .padding(20)
            
            HStack{
                Text("Apellido Materno: ")
                    .font(.title2)
                TextField("Apellidos", text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
                    .font(.title2)
            }
            .frame(width: 360)
            .padding(20)
            
            Picker(selection: $sexoSeleccionado, label: Text("Seleciona una opcion")){
                ForEach(opciones.indices, id: \.self){
                    Text(self.opciones[$0]).tag($0)
                }
            }
            .frame(width: 360)
            .pickerStyle(SegmentedPickerStyle())

            
            Button("Nuevo") {
                
            }
            .frame(width: 360)
            .padding(50)
            .font(.largeTitle)
            .foregroundStyle(.red)
            .buttonStyle(GrowingButton())
        }
    }
}

#Preview {
    AltaAlumunoView()
}
