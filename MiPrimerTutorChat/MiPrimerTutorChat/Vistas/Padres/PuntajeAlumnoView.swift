//
//  PuntajeAlumnoView.swift
//  MiPrimerTutorChat
//
//  Created by Irving Alejandro Vega Lagunas on 26/11/23.
//

import SwiftUI

struct PuntajeAlumnoView: View {
    let nombresDeAlumnos = ["Alumno 1", "Alumno 2", "Alumno 3"]
    @State private var alumnoSeleccionado = "Alumno 1"
    let nombresDeMateria = ["Materia 1", "Materia 2", "Materia 3"]
    @State private var materiaSeleccionado = "Materia 1"
    
    var body: some View {
        VStack{
            Text("Puntaje Alumno")
                .font(.system(size: 36, weight: .heavy, design: .rounded))
                .multilineTextAlignment(.center)
                .padding(20)
            
            Form {
                Picker("Materia", selection: $materiaSeleccionado) {
                    ForEach(nombresDeMateria, id: \.self) { materia in
                        Text(materia).tag(materia)
                    }
                }
                .font(.system(size: 22, design: .rounded))
            }
            .frame(height: 100)
            
            Image(systemName: "chart.dots.scatter")
                .resizable()
                .scaledToFit()
                .cornerRadius(10)
                .padding()
                .foregroundStyle(.blue)
            
            List {
                Text("Datos:")
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

    }}

#Preview {
    PuntajeAlumnoView()
}