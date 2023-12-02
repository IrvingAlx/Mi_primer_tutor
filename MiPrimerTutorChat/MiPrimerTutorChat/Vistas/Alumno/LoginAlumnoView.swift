//
//  LoginAlumnoView.swift
//  MiPrimerTutorChat
//
//  Created by Irving Alejandro Vega Lagunas on 26/11/23.
//

import SwiftUI

struct LoginAlumnoView: View {
    @State private var username = ""
    @State private var idAlumno: Int? = nil
    @State private var errorMessage: String? = nil
    
    var body: some View {
        VStack {
            Text("Bienvenido")
                .font(.system(size: 36, weight: .heavy, design: .rounded))
                .multilineTextAlignment(.center)
                .padding(50)
                
            Image(systemName: "ladybug.fill")
                .resizable()
                .scaledToFit()
                .imageScale(.large)
                .cornerRadius(10)
                .padding()
                .foregroundStyle(.blue)
                
            HStack {
                TextField("Usuario", text: $username)
                    .font(.title)
                    .padding(20)
            }
                
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding(20)
            }
                
            NavigationLink(destination: MenuAlumnoView(idAlumno: idAlumno ?? 0), isActive: Binding<Bool>(
                get: { idAlumno != nil },
                set: { _ in }
            )) {
                Button("Aceptar") {
                    loginAlumno()
                }
                .font(.largeTitle)
                .tint(.blue)
                .padding()
                .buttonStyle(GrowingButton())
            }

        }
    }
    
    func loginAlumno() {
        guard let url = URL(string: "http://127.0.0.1:8000/login_alumno") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let alumnoData = ["nombre": username]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: alumnoData)
        } catch {
            print("Error al convertir datos a JSON: \(error.localizedDescription)")
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    if let idAlumno = json?["id_alumno"] as? Int {
                        // El alumno fue encontrado, redirige a la vista de menú
                        DispatchQueue.main.async {
                            self.idAlumno = idAlumno
                        }
                    } else {
                        // El alumno no fue encontrado, muestra un mensaje de error
                        DispatchQueue.main.async {
                            self.errorMessage = "Usuario no encontrado"
                        }
                    }
                } catch {
                    print("Error al decodificar la respuesta JSON: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
}
#Preview {
    LoginAlumnoView()
}
