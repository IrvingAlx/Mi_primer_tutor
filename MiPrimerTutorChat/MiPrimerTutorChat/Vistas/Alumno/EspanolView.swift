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
            Image(pregunta.nombre_imagen)  // Asumiendo que el nombre de la imagen es el mismo que en el catálogo de activos
                .resizable()
                .scaledToFit()
                .imageScale(.medium)
                .cornerRadius(10)
                .padding()
                        
            HStack {
                Button("A)") {
                    // Acciones cuando se selecciona A)
                }
                .font(.largeTitle)
                .padding()
                .buttonStyle(AButton())

                Button("B)") {
                    // Acciones cuando se selecciona B)
                }
                .font(.largeTitle)
                .padding()
                .buttonStyle(BButton())
            }

            HStack {
                Button("C)") {
                    // Acciones cuando se selecciona C)
                }
                .font(.largeTitle)
                .padding()
                .buttonStyle(CButton())

                Button("D)") {
                    // Acciones cuando se selecciona D)
                }
                .font(.largeTitle)
                .padding()
                .buttonStyle(DButton())
            }

            HStack {
                Button("Regresar") {
                    // Acciones cuando se presiona Aceptar
                }
                .font(.largeTitle)
                .tint(.blue)
                .padding()
                .buttonStyle(GrowingButton())
            }
        }
        .padding()
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
