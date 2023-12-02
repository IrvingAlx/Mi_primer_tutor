//
//  ListaAlumnosView.swift
//  MiPrimerTutorChat
//
//  Created by Irving Alejandro Vega Lagunas on 26/11/23.
//

import SwiftUI

struct ListaAlumnosView: View {
    
    @State private var uid = FirebaseManager.shared.auth.currentUser?.uid
    @State private var nombresDeAlumnos: [String] = []
    @State private var alumnoSeleccionado = ""

    var body: some View {
        VStack {
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
                ForEach(nombresDeAlumnos, id: \.self) { nombre in
                    Text("Nombre: \(nombre)")
                        .font(.title)
                }
            }
        }
        .onAppear {
            obtenerListaAlumnos()
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
                print("Error al cargar la lista de alumnos: \(error?.localizedDescription ?? "Desconocido")")
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let alumnos = json?["alumnos"] as? [[String: Any]] {
                    nombresDeAlumnos = alumnos.map { $0["nombre"] as? String ?? "" }
                    // Puedes agregar más lógica aquí según tus necesidades
                }
            } catch {
                print("Error al decodificar la respuesta JSON: \(error.localizedDescription)")
            }
        }.resume()
    }
}

#Preview {
    ListaAlumnosView()
}
