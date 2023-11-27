//
//  ListaAlumnosView.swift
//  MiPrimerTutorChat
//
//  Created by Irving Alejandro Vega Lagunas on 26/11/23.
//

import SwiftUI

struct ListaAlumnosView: View {
    let nombresDeAlumnos = ["Alumno 1", "Alumno 2", "Alumno 3"]
    @State private var alumnoSeleccionado = "Alumno 1"
    
    var body: some View {
        VStack{
            Text("Lista Alumnos")
                .font(.system(size: 36, weight: .heavy, design: .rounded))
                .multilineTextAlignment(.center)
                .padding(20)
    
            Image(systemName: "books.vertical")
                .resizable()
                .scaledToFit()
                .imageScale(.large)
                .cornerRadius(10)
                .padding()
                .foregroundStyle(.blue)
                .frame(width: 200)
            
            Form {
                Picker("Alumno", selection: $alumnoSeleccionado) {
                    ForEach(nombresDeAlumnos, id: \.self) { nombre in
                        Text(nombre).tag(nombre)
                    }
                }
                .font(.system(size: 22, design: .rounded))
            }
            .frame(height: 100)
            
            
            
            List {
                Text("Nombre:")
                    .font(.title)
                
                /*if !cuentasInfo.isEmpty {
                    Text("No Cuenta:")
                        .font(.title)
                } else {
                    Text("No Cuenta: No hay cuentas disponibles") // Muestra un mensaje si no hay cuentas
                        .font(.title)
                }*/
            }
        }
        /*.onAppear {
            obtenerClientes()
        }
        .onChange(of: clienteSeleccionado) { selectedCliente in
            obtenerDatosDelCliente()
        }*/

    }
}

#Preview {
    ListaAlumnosView()
}
