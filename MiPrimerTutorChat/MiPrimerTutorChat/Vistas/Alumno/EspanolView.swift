//
//  EspanolView.swift
//  MiPrimerTutorChat
//
//  Created by Irving Alejandro Vega Lagunas on 26/11/23.
//

import SwiftUI
import URLImage

struct EspanolView: View {
    var idAlumno: Int

    @State private var preguntas: [Pregunta] = []
    @State private var preguntaActualIndex: Int = 0
    @State private var opcionSeleccionada: String?
    @State private var progreso: Double = 0
    @State private var nivelActual: Int = 1 // Variable de estado para rastrear el nivel actual
    @State private var nivelTransicionIniciada: Bool = false
    @State private var isLoading: Bool = true



    var body: some View {
        VStack {
            Text("Español")
                .font(.system(size: 36, weight: .heavy, design: .rounded))
                .multilineTextAlignment(.center)
                .padding(20)

            Text("Nivel \(nivelActual)") // Nuevo Text para mostrar el número de nivel actual

            if preguntas.isEmpty {
                Text("Cargando preguntas...")
                    .padding()
            } else if preguntaActualIndex < preguntas.count {
                cargarContenidoPregunta(pregunta: preguntas[preguntaActualIndex])
            } else {
                Text("Fin de las preguntas del nivel \(nivelActual)")
                    .padding()
                    .onAppear {
                        pasarAlSiguienteNivel()
                    }
            }
        }
        .onAppear {
            if isLoading {
                cargarPreguntas(area: "espanol", numeroNivel: 1)
            }
        }
    }

    func cargarContenidoPregunta(pregunta: Pregunta) -> some View {
        VStack {
            HStack {
                Gauge(value: progreso, in: 0...Double(preguntas.count)) {
                    Text("Progreso")
                }
                .padding()
            }
            Image(pregunta.nombre_imagen)
                .resizable()
                .scaledToFit()
                .imageScale(.medium)
                .cornerRadius(10)
                .padding()

            HStack {
                Button("A)") {
                    verificarRespuesta("a", correcta: pregunta.respuesta_correcta)
                }
                .font(.largeTitle)
                .padding()
                .buttonStyle(AButton())

                Button("B)") {
                    verificarRespuesta("b", correcta: pregunta.respuesta_correcta)
                }
                .font(.largeTitle)
                .padding()
                .buttonStyle(BButton())
            }

            HStack {
                Button("C)") {
                    verificarRespuesta("c", correcta: pregunta.respuesta_correcta)
                }
                .font(.largeTitle)
                .padding()
                .buttonStyle(CButton())

                Button("D)") {
                    verificarRespuesta("d", correcta: pregunta.respuesta_correcta)
                }
                .font(.largeTitle)
                .padding()
                .buttonStyle(DButton())
            }

            if let respuesta = opcionSeleccionada {
                Text("Respuesta: \(respuesta == pregunta.respuesta_correcta ? "Correcta" : "Incorrecta")")
                    .padding()
            }

            /*HStack {
                Button("Regresar") {
                    // Acciones cuando se presiona Regresar
                }
                .font(.largeTitle)
                .tint(.blue)
                .padding()
                .buttonStyle(GrowingButton())
            }*/
        }
        .padding()
    }

    func verificarRespuesta(_ opcion: String, correcta: String) {
        opcionSeleccionada = opcion
        if opcion == correcta {
            progreso += 1 // Incrementar el progreso si la respuesta es correcta
            guardarPuntuacion()
            cargarSiguientePregunta()
        }
    }

    // Nueva función para guardar la puntuación
    func guardarPuntuacion() {
        guard let url = URL(string: "http://127.0.0.1:8000/guardar_puntuacion") else {
            return
        }

        let puntuacionData: [String: Any] = [
            "id_alumno": idAlumno,
            "id_nivel": nivelActual,
            "puntos_acumulados": progreso
        ]
        
        print("Datos a enviar al servidor: ", puntuacionData) // Imprime los datos antes de enviarlos al servidor


        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: puntuacionData, options: .prettyPrinted)
        } catch let error {
            print("Error al serializar los datos de la puntuación: \(error)")
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error en la solicitud HTTP al guardar la puntuación: \(error)")
                return
            }

            guard let data = data else {
                print("No se recibieron datos en la respuesta.")
                return
            }

            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let message = jsonResponse?["message"] as? String {
                    print("Respuesta del servidor: \(message)")
                }
            } catch {
                print("Error al decodificar la respuesta del servidor: \(error)")
            }
        }.resume()

    }


    func cargarSiguientePregunta() {
        preguntaActualIndex += 1
        opcionSeleccionada = nil // Restablecer la opción seleccionada al cargar una nueva pregunta

        if preguntaActualIndex >= preguntas.count {
            // Si hemos alcanzado el final de las preguntas del nivel actual, pasa al siguiente nivel
            pasarAlSiguienteNivel()
        }
    }

    func pasarAlSiguienteNivel() {
        nivelTransicionIniciada = true
        nivelActual += 1
        preguntaActualIndex = 0 // Reiniciar el índice de la pregunta al pasar al siguiente nivel
        progreso = 0 // Reiniciar el progreso al pasar a un nuevo nivel

        // Realizar la solicitud HTTP para obtener las preguntas del nuevo nivel
        guard let url = URL(string: "http://127.0.0.1:8000/preguntas_por_categoria?area=espanol&numero_nivel=\(nivelActual)") else {
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                do {
                    let respuesta = try JSONDecoder().decode(PreguntaResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.preguntas = respuesta.preguntas
                    }
                } catch {
                    print("Error al decodificar la respuesta: \(error)")
                }
            } else if let error = error {
                print("Error en la solicitud HTTP: \(error)")
            }
        }.resume()
        nivelTransicionIniciada = false
    }

    func obtenerPreguntasIniciales() {
        // Realizar la solicitud HTTP para obtener las preguntas iniciales del primer nivel
        guard let url = URL(string: "http://127.0.0.1:8000/preguntas_por_categoria?area=espanol&numero_nivel=1") else {
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                do {
                    let respuesta = try JSONDecoder().decode(PreguntaResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.preguntas = respuesta.preguntas
                    }
                } catch {
                    print("Error al decodificar la respuesta: \(error)")
                }
            } else if let error = error {
                print("Error en la solicitud HTTP : \(error)")
            }
        }.resume()
    }
    
    func cargarPreguntas(area: String, numeroNivel: Int) {
        guard let url = URL(string: "http://127.0.0.1:8000/preguntas_por_categoria?area=\(area)&numero_nivel=\(numeroNivel)") else {
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false // Cambiar el estado de carga independientemente del resultado

                guard let data = data, error == nil else {
                    print("Error en la solicitud HTTP: \(error?.localizedDescription ?? "Error desconocido")")
                    return
                }

                do {
                    let respuesta = try JSONDecoder().decode(PreguntaResponse.self, from: data)
                    preguntas = respuesta.preguntas
                } catch {
                    print("Error al decodificar la respuesta: \(error)")
                }
            }
        }.resume()
    }
}

struct PreguntaResponse: Codable {
    let preguntas: [Pregunta]
}

struct Pregunta: Codable {
    let numero_pregunta: Int
    let nombre_imagen: String
    let respuesta_correcta: String
}


#Preview {
    EspanolView(idAlumno: 1)
}
