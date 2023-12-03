//
//  MatematicasView.swift
//  MiPrimerTutorChat
//
//  Created by Irving Alejandro Vega Lagunas on 26/11/23.
//

import SwiftUI
import URLImage

struct MatematicasView: View {
    var idAlumno: Int
    
    @State private var preguntas: [Pregunta] = []
    @State private var preguntaActualIndex: Int = 0
    @State private var opcionSeleccionada: String?
    @State private var progreso: Double = 0
    @State private var nivelActual: Int = 1
    @State private var nivelTransicionIniciada: Bool = false
    @State private var isLoading: Bool = true
    let maximoNivel: Int = 3  // Reemplaza 5 con el número máximo de niveles que tienes

    var body: some View {
        VStack {
            Text("Matematicas")
                .font(.system(size: 36, weight: .heavy, design: .rounded))
                .multilineTextAlignment(.center)
                .padding(20)
            
            Text("Nivel \(nivelActual)")

            if preguntas.isEmpty {
                Text("Cargando preguntas...")
                    .padding()
            } else if preguntaActualIndex < preguntas.count {
                cargarContenidoPregunta(pregunta: preguntas[preguntaActualIndex])
            }else {
                if nivelActual > 2 {
                    Text("¡Felicidades! Has completado el nivel \(nivelActual)")
                        .padding()
                        .onAppear {
                            pasarAlSiguienteNivel()
                        }
                } else {
                    // Muestra un mensaje de felicitaciones y la opción de regresar al menú del alumno
                    VStack {
                        Text("¡Felicidades! Has completado todos los niveles.")
                            .font(.headline)
                            .padding()
                        
                        Button("Regresar al Menú del Alumno") {
                            // Acciones cuando se presiona el botón para regresar al menú del alumno
                            // Puedes navegar a la vista del menú del alumno o realizar cualquier acción deseada.
                        }
                        .padding()
                        .buttonStyle(GrowingButton()) // Reemplaza YourButtonStyle con el estilo de botón que estás utilizando
                    }
                }
            }

        }
        .onAppear {
            if isLoading {
                cargarPreguntas(area: "matematicas", numeroNivel: nivelActual)
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
        }
        .padding()
    }

    func verificarRespuesta(_ opcion: String, correcta: String) {
        opcionSeleccionada = opcion
        if opcion == correcta {
            progreso += 1 // Incrementar el progreso si la respuesta es correcta
            guardarPuntuacion {
                cargarSiguientePregunta()
            }
        }
    }

    // Nueva función para guardar la puntuación
    func guardarPuntuacion(completion: @escaping () -> Void) {
        guard let url = URL(string: "http://127.0.0.1:8000/guardar_puntuacion") else {
            return
        }

        let puntuacionData: [String: Any] = [
            "id_alumno": idAlumno,
            "id_nivel": 5,
            "puntos_acumulados": progreso
        ]

        print("Datos a enviar al servidor: ", puntuacionData)

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
                completion() // Llamar a la clausura de finalización después de que la respuesta se ha procesado
            } catch {
                print("Error al decodificar la respuesta del servidor: \(error)")
            }

            // Retrasar la ejecución de la siguiente acción para permitir que la conexión se estabilice
            /*DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.cargarSiguientePregunta()
            }*/

        }.resume()
    }



    func cargarSiguientePregunta() {
        preguntaActualIndex += 1
        opcionSeleccionada = nil

        if preguntaActualIndex < preguntas.count {
            DispatchQueue.main.async {
                self.cargarContenidoPregunta(pregunta: self.preguntas[self.preguntaActualIndex])
            }
        } else {
            pasarAlSiguienteNivel()
        }
    }


    func pasarAlSiguienteNivel() {
        nivelTransicionIniciada = true
        nivelActual += 1
        preguntaActualIndex = 0
        progreso = 0

        // Realizar la solicitud HTTP para obtener las preguntas del nuevo nivel
        guard let url = URL(string: "http://127.0.0.1:8000/preguntas_por_categoria?area=matematicas&numero_nivel=\(nivelActual)") else {
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                do {
                    let respuesta = try JSONDecoder().decode(PreguntaResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.preguntas = respuesta.preguntas

                        // Asegurarse de que la carga de preguntas del siguiente nivel se haya completado
                        self.nivelTransicionIniciada = false

                        // Mostrar el mensaje de felicitaciones después de actualizar la interfaz de usuario
                        if self.nivelActual <= self.maximoNivel {
                            self.cargarContenidoPregunta(pregunta: self.preguntas[self.preguntaActualIndex])
                        }
                    }
                } catch {
                    print("Error al decodificar la respuesta: \(error)")
                }
            } else if let error = error {
                print("Error en la solicitud HTTP: \(error)")
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

#Preview {
    MatematicasView(idAlumno: 1)
}
