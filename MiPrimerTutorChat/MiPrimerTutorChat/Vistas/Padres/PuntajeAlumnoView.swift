//
//  PuntajeAlumnoView.swift
//  MiPrimerTutorChat
//
//  Created by Irving Alejandro Vega Lagunas on 26/11/23.
//

import SwiftUI

struct PuntajeAlumnoView: View {
    
    @State private var uid = FirebaseManager.shared.auth.currentUser?.uid
    @State private var nombresDeAlumnos: [String] = []
    @State private var alumnoSeleccionado = ""
    @State private var todasLasMaterias: [String] = []
    @State private var materiaSeleccionada = ""
    @State private var puntuaciones: [PuntuacionModel] = []

    var body: some View {
        VStack {
            Text("Puntaje Alumnos")
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
            
            Button(action: {
                cargarPuntuaciones()
            }) {
                Text("Buscar Puntuaciones")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
            }
            
            List {
                if materiaSeleccionada.isEmpty {
                    Text("Selecciona una materia")
                        .foregroundColor(.red)
                } else {
                    if puntuaciones.isEmpty {
                        Text("No hay puntuaciones disponibles")
                            .foregroundColor(.red)
                    } else {
                        ForEach(puntuaciones) { puntuacion in
                            VStack(alignment: .leading) {
                                Text("Fecha: \(puntuacion.fecha)")
                                    .font(.headline)
                                Text("Puntos acumulados: \(puntuacion.puntos)")
                                    .font(.subheadline)
                            }
                        }
                    }
                }
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
        
        guard let url = URL(string: "http://127.0.0.1:8000/lista_alumnos_padres?id_usuario_padre=\(uid)") else {
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
        
        guard let url = URL(string: "http://127.0.0.1:8000/lista_materias_padres?id_usuario_padre=\(uid)") else {
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
    
    func obtenerPuntuaciones() {
        guard let uid = uid, !alumnoSeleccionado.isEmpty, !materiaSeleccionada.isEmpty else {
            print("Error: Datos insuficientes para obtener puntuaciones")
            return
        }
        
        guard let url = URL(string: "http://127.0.0.1:8000/obtener_puntuacion") else {
            print("Error: URL no válida")
            return
        }
        
        let body: [String: Any] = [
            "nombre_alumno": alumnoSeleccionado,
            "materia": materiaSeleccionada
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            print("Error al serializar datos JSON: \(error.localizedDescription)")
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error al cargar las puntuaciones: \(error?.localizedDescription ?? "Desconocido")")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let puntuacionesData = try decoder.decode([PuntuacionModel].self, from: data)
                DispatchQueue.main.async {
                    self.puntuaciones = puntuacionesData
                }
            } catch {
                print("Error al decodificar la respuesta JSON: \(error.localizedDescription)")
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    if let puntuaciones = json?["puntuaciones"] as? [[String: Any]] {
                        let puntuacionesData = puntuaciones.map {
                            PuntuacionModel(
                                id_puntuacion: $0["id_puntuacion"] as? Int ?? 0,
                                fecha: $0["fecha_completado"] as? String ?? "",
                                puntos: $0["puntos_acumulados"] as? Int ?? 0
                            )
                        }
                        DispatchQueue.main.async {
                            self.puntuaciones = puntuacionesData
                        }
                    } else {
                        print("Error: El formato JSON no es el esperado")
                    }
                } catch {
                    print("Error al manejar el nuevo formato JSON: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
    
    func cargarPuntuaciones() {
        obtenerPuntuaciones()
    }
}

#Preview {
    PuntajeAlumnoView()
}
