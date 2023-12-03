//
//  ProgresoAlumnosView.swift
//  MiPrimerTutorChat
//
//  Created by Irving Alejandro Vega Lagunas on 26/11/23.
//

import SwiftUI

struct ProgresoAlumnosView: View {
    
    @State private var uid = FirebaseManager.shared.auth.currentUser?.uid
    @State private var nombresDeAlumnos: [String] = []
    @State private var alumnoSeleccionado = ""
    @State private var todasLasMaterias: [String] = []
    @State private var materiaSeleccionada = ""

    var body: some View {
        VStack {
            Text("Progreso Alumnos")
                .font(.system(size: 36, weight: .heavy, design: .rounded))
                .multilineTextAlignment(.center)
                .padding(20)

            Form {
                Picker("Alumno", selection: $alumnoSeleccionado) {
                    ForEach(nombresDeAlumnos, id: \.self) { nombre in
                        Text(nombre).tag(nombre)
                    }
                }
                .font(.system(size: 22, design: .rounded))
            }
            .frame(height: 100)

            Form {
                Text("Alumno seleccionado: \(alumnoSeleccionado)")

                Picker("Materia", selection: $materiaSeleccionada) {
                    ForEach(todasLasMaterias, id: \.self) { materia in
                        Text(materia).tag(materia)
                    }
                }
                .font(.system(size: 22, design: .rounded))
                .disabled(alumnoSeleccionado.isEmpty)
            }
            .frame(height: 150)
            
            Image(systemName: "chart.pie")
                .resizable()
                .scaledToFit()
                .cornerRadius(10)
                .padding()
                .foregroundStyle(.blue)

            List {
                Text("Datos: ")
                    .font(.title)
            }
        }
        .onAppear {
            obtenerListaAlumnos()
            DispatchQueue.main.async {
                obtenerListaMaterias()
            }
        }
    }
    
    func obtenerListaAlumnos() {
        guard let uid = uid else {
            print("Error: UID no disponible")
            return
        }

        guard let url = URL(string: "http://127.0.0.1:8000/lista_alumnos?id_usuario_profesor=\(uid)") else {
            print("Error: URL no válida")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error al cargar la lista de alumnos : \(error?.localizedDescription ?? "Desconocido")")
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let alumnos = json?["alumnos"] as? [[String: Any]] {
                    nombresDeAlumnos = alumnos.map { $0["nombre"] as? String ?? "" }
                }
            } catch {
                print("Error al decodificar la respuesta JSON: \(error.localizedDescription)")
            }
        }.resume()
    }

    func obtenerListaMaterias() {
        guard let uid = uid else {
            print("Error: UID no disponible")
            return
        }

        guard let url = URL(string: "http://127.0.0.1:8000/lista_materias?id_usuario_profesor=\(uid)") else {
            print("Error: URL no válida")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error al cargar la lista de materias: \(error?.localizedDescription ?? "Desconocido")")
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let materiasPorAlumnoJSON = json?["alumnos_materias"] as? [[String: Any]] {
                    DispatchQueue.main.async {
                        let materiasSet = Set(materiasPorAlumnoJSON.flatMap { $0["materias"] as? [String] ?? [] })
                        todasLasMaterias = Array(materiasSet)
                        print("Todas las materias: \(todasLasMaterias)")
                    }
                }
            } catch {
                print("Error al decodificar la respuesta JSON: \(error.localizedDescription)")
            }
        }.resume()
    }
}


#Preview {
    ProgresoAlumnosView()
}
