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
            obtenerPreguntasIniciales()
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

            HStack {
                Button("Regresar") {
                    // Acciones cuando se presiona Regresar
                }
                .font(.largeTitle)
                .tint(.blue)
                .padding()
                .buttonStyle(GrowingButton())
            }
        }
        .padding()
    }

    func verificarRespuesta(_ opcion: String, correcta: String) {
        opcionSeleccionada = opcion
        if opcion == correcta {
            progreso += 1 // Incrementar el progreso si la respuesta es correcta
            cargarSiguientePregunta()
        }
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
}

struct PreguntaResponse: Decodable {
    let preguntas: [Pregunta]
}

struct Pregunta: Decodable {
    let numero_pregunta: Int
    let nombre_imagen: String
    let respuesta_correcta: String
}


#Preview {
    EspanolView(idAlumno: 1)
}
