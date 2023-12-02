//
//  AltaAlumunoView.swift
//  MiPrimerTutorChat
//
//  Created by Irving Alejandro Vega Lagunas on 26/11/23.
//

import SwiftUI

struct AltaAlumunoView: View {
    
    @State private var uid = FirebaseManager.shared.auth.currentUser?.uid
    @State private var nombre : String = ""
    @State private var apellidoPaterno : String = ""
    @State private var apellidoMaterno : String = ""
    

    
    var body: some View {
        VStack{
            Text("Alta Alumno")
                .font(.system(size: 36, weight: .heavy, design: .rounded))
                .multilineTextAlignment(.center)
                .padding(20)
            Image(systemName: "person")
                .resizable()
                .scaledToFit()
                .imageScale(.large)
                .cornerRadius(10)
                .frame(width: 150)
                .padding(20)
            HStack{
                Text("Nombres: ")
                    .font(.title2)
                TextField("Nombre", text: $nombre)
                    .font(.title2)
            }
            .frame(width: 360)
            .padding(20)
            HStack{
                Text("Apellido Paterno: ")
                    .font(.title2)
                TextField("Apellidos", text: $apellidoPaterno)
                    .font(.title2)
            }
            .frame(width: 360)
            .padding(20)
            
            HStack{
                Text("Apellido Materno: ")
                    .font(.title2)
                TextField("Apellidos", text: $apellidoMaterno)
                    .font(.title2)
            }
            .frame(width: 360)
            .padding(20)
            
          
            
            Button("Registrar Alumno") {
                altaAlumno()
            }
            .frame(width: 360)
            .padding(50)
            .font(.largeTitle)
            .foregroundStyle(.red)
            .buttonStyle(GrowingButton())
                       
        }
    }
    
    
    func altaAlumno() {
        guard let uid = uid else {
            print("Error: UID no disponible")
            return
        }

        let nombreCompleto = "\(nombre) \(apellidoPaterno) \(apellidoMaterno)"

        let alumnoData = [
            "uid": uid,
            "nombre": nombreCompleto,
            // Puedes agregar más campos según sea necesario
        ]

        guard let url = URL(string: "http://127.0.0.1:8000/alta_alumno") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: alumnoData)
        } catch {
            print("Error al convertir datos a JSON: \(error.localizedDescription)")
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            // Manejar la respuesta del servidor
            if let data = data {
                do {
                    // Imprimir los datos brutos
                    print(String(data: data, encoding: .utf8) ?? "No se pueden imprimir los datos")

                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print("Respuesta del servidor: \(json)")
                } catch {
                    print("Error al decodificar la respuesta JSON: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
}




#Preview {
    AltaAlumunoView()
}
