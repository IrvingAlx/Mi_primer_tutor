//
//  LoginView.swift
//  MiPrimerTutorChat
//
//  Created by Irving Alejandro Vega Lagunas on 20/11/23.
//

import SwiftUI
import Firebase
import FirebaseStorage

struct LoginView: View {
    
    let didCompleteLoginProcess: (UserType) -> () // Modifica el tipo de la clausura para incluir un UserType

    @State private var isLoginMode = false
    @State private var email = ""
    @State private var password = ""
    
    @State var shouldShowImagePicker = false
    
    var userType: UserType // Nueva propiedad para indicar el tipo de usuario

    
    var body: some View {
        NavigationView {
            ScrollView {
                
                VStack(spacing: 16) {
                    Picker(selection: $isLoginMode, label: Text("Escoger Aqui")) {
                        Text("Login")
                            .tag(true)
                        Text("Crear Cuenta")
                            .tag(false)
                    }.pickerStyle(SegmentedPickerStyle())
                        
                    if !isLoginMode {
                        Button {
                            shouldShowImagePicker.toggle()
                        } label: {
                            
                            VStack {
                                if let image = self.image {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 128, height: 128)
                                        .cornerRadius(64)
                                } else {
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 64))
                                        .padding()
                                        .foregroundColor(Color(.label))
                                }
                            }
                            .overlay(RoundedRectangle(cornerRadius: 64)
                                        .stroke(Color.black, lineWidth: 3)
                            )
                            
                        }
                    }
                    
                    Group {
                        TextField("Correo", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                        SecureField("Contraseña", text: $password)
                    }
                    .padding(12)
                    .background(Color.white)
                    
                    Button {
                        handleAction()
                    } label: {
                        HStack {
                            Spacer()
                            Text(isLoginMode ? "Login" : "Crear Cuenta")
                                .foregroundColor(.white)
                                .padding(.vertical, 5)
                                .font(.system(size: 28, weight: .semibold))
                            Spacer()
                        }.foregroundColor(.white)
                            .padding(.vertical)
                                .background(Color.blue)
                                .cornerRadius(32)
                                .padding(.horizontal)
                                .shadow(radius: 15)
                        
                    }
                    
                    NavigationLink("Regresar", destination: ContentView())
                        .font(.largeTitle)
                        .tint(.blue)
                        .padding()
                        .buttonStyle(GrowingButton())
                    
                    Text(self.loginStatusMessage)
                        .foregroundColor(.red)
                }
                .padding()
                
            }
            .navigationTitle(isLoginMode ? "Login" : "Crear Cuenta")
            .background(Color(.init(white: 0, alpha: 0.05))
                            .ignoresSafeArea())
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
            ImagePicker(image: $image)
                .ignoresSafeArea()
        }
    }
    
    @State var image: UIImage?
    
    private func handleAction() {
        if isLoginMode {
            loginUser()
        } else {
            createNewAccount()
        }
    }
    
    private func loginUser() {
        FirebaseManager.shared.auth.signIn(withEmail: email, password: password) { result, err in
            if let err = err {
                print("Error al logear usuario:", err)
                self.loginStatusMessage = "Error al logear usuario: \(err)"
                return
            }
            
            print("Usuario exitosamente Logeado: \(result?.user.uid ?? "")")
            
            self.loginStatusMessage = "Usuario exitosamente Logeado: \(result?.user.uid ?? "")"
            
            self.didCompleteLoginProcess(.professor)
        }
    }
    
    @State var loginStatusMessage = ""
    
    private func createNewAccount() {
        if self.image == nil {
            self.loginStatusMessage = "Debes selecionar un avatar"
            return
        }
        FirebaseManager.shared.auth.createUser(withEmail: email, password: password) { result, err in
            if let err = err {
                print("Error al crear usuario:", err)
                self.loginStatusMessage = "Error al crear usuario: \(err)"
                return
            }
            
            guard let uid = result?.user.uid else {
                self.loginStatusMessage = "Error al obtener UID del usuario creado"
                return
            }
            
            print("Usuario creado exitosamente: \(result?.user.uid ?? "")")
            
            self.loginStatusMessage = "Usuario creado exitosamente: \(result?.user.uid ?? "")"
            
            self.persistImageToStorage()
            
            // Datos a enviar al servidor Flask
            let userData = [
                "email": email,
                "uid": uid,
                "contrasena": password,
                "tipo_usuario": userType == .professor ? "profesor" : "padre"
            ]

            // Realizar la solicitud al servidor Flask
            guard let url = URL(string: "http://127.0.0.1:8000/crear_usuario") else { return }
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")

            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: userData)
            } catch {
                print("Error al convertir datos a JSON: \(error.localizedDescription)")
                return
            }

            URLSession.shared.dataTask(with: request) { data, response, error in
                // Manejar la respuesta del servidor
            }.resume()
        }
    }
    
    private func persistImageToStorage() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        let ref = FirebaseManager.shared.storage.reference(withPath: uid)
        guard let imageData = self.image?.jpegData(compressionQuality: 0.5) else { return }
        ref.putData(imageData, metadata: nil) { metadata, err in
            if let err = err {
                self.loginStatusMessage = "Failed to push image to Storage: \(err)"
                return
            }
            
            ref.downloadURL { url, err in
                if let err = err {
                    self.loginStatusMessage = "Failed to retrieve downloadURL: \(err)"
                    return
                }
                
                self.loginStatusMessage = "Successfully stored image with url: \(url?.absoluteString ?? "")"
                print(url?.absoluteString ?? "")
                
                guard let url = url else { return }
                self.storeUserInformation(imageProfileUrl: url)
            }
        }
    }
    enum UserType {
        case professor
        case parent
    }
    
    // Aqui al momento de mandar email uid y profileImageUrl guardar en mysql de sebas aprovechando en la tabla usuarios
    
    private func storeUserInformation(imageProfileUrl: URL) {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        let userData = [FirebaseConstants.email: self.email, FirebaseConstants.uid: uid, FirebaseConstants.profileImageUrl: imageProfileUrl.absoluteString]
        FirebaseManager.shared.firestore.collection(FirebaseConstants.users)
            .document(uid).setData(userData) { err in
                if let err = err {
                    print(err)
                    self.loginStatusMessage = "\(err)"
                    return
                }
                
                print("Success")
                
                self.didCompleteLoginProcess(.professor)
            }
    }
}

#Preview {
    LoginView(didCompleteLoginProcess: { userType in
            // Puedes proporcionar un valor para userType aquí, por ejemplo .professor
        }, userType: .professor)
        
}
