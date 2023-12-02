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

    @State private var pregunta: Pregunta?
    @State private var opcionSeleccionada: String?

    var body: some View {
        VStack {
            Text("Español")
                .font(.system(size: 36, weight: .heavy, design: .rounded))
                .multilineTextAlignment(.center)
                .padding(20)

            if let pregunta = pregunta {
                cargarContenidoPregunta(pregunta: pregunta)
            } else {
                Text("Cargando pregunta...")
                    .padding()
            }
        }
        .onAppear {
            obtenerPreguntaInicial()
        }
    }

    func cargarContenidoPregunta(pregunta: Pregunta) -> some View {
        VStack {
            Image(pregunta.nombre_imagen)
                .resizable()
                .scaledToFit()
                .imageScale(.medium)
                .cornerRadius(10)
                .padding()

            HStack {
                Button("A)") {
                    seleccionarOpcion("a")
                }
                .font(.largeTitle)
                .padding()
                .buttonStyle(AButton())

                Button("B)") {
                    seleccionarOpcion("b")
                }
                .font(.largeTitle)
                .padding()
                .buttonStyle(BButton())
            }

            HStack {
                Button("C)") {
                    seleccionarOpcion("c")
                }
                .font(.largeTitle)
                .padding()
                .buttonStyle(CButton())

                Button("D)") {
                    seleccionarOpcion("d")
                }
                .font(.largeTitle)
                .padding()
                .buttonStyle(DButton())
            }

            Text("Respuesta: \(opcionSeleccionada == pregunta.respuesta_correcta ? "Correcta" : "Incorrecta")")
                .padding()

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

    func seleccionarOpcion(_ opcion: String) {
        opcionSeleccionada = opcion
    }

    func obtenerPreguntaInicial() {
        // Realizar la solicitud HTTP para obtener la pregunta inicial
        guard let url = URL(string: "http://127.0.0.1:8000/preguntas_por_categoria?area=espanol&numero_nivel=1") else {
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                do {
                    let respuesta = try JSONDecoder().decode(PreguntaResponse.self, from: data)
                    guard let pregunta = respuesta.preguntas.first else {
                        print("No se encontraron preguntas en la respuesta")
                        return
                    }

                    DispatchQueue.main.async {
                        self.pregunta = pregunta
                        self.opcionSeleccionada = nil // Restablecer la opción seleccionada al cargar una nueva pregunta
                    }
                } catch {
                    print("Error al decodificar la respuesta: \(error)")
                }
            } else if let error = error {
                print("Error en la solicitud HTTP: \(error)")
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
