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
    
    let didCompleteLoginProcess: () -> ()
    
    @State private var isLoginMode = false
    @State private var email = ""
    @State private var password = ""
    
    @State var shouldShowImagePicker = false
    
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
            
            self.didCompleteLoginProcess()
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
            
            print("Usuario creado exitosamente: \(result?.user.uid ?? "")")
            
            self.loginStatusMessage = "Usuario creado exitosamente: \(result?.user.uid ?? "")"
            
            self.persistImageToStorage()
        }
    }
    
    private func persistImageToStorage() {
        let filename = UUID().uuidString
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        let ref = FirebaseManager.shared.storage.reference(withPath: uid)
        guard let imageData = self.image?.jpegData(compressionQuality: 0.5) else { return }
        ref.putData(imageData, metadata: nil) { metadata, err in
            if let err = err {
                self.loginStatusMessage = "Error al guardar imagen en storage: \(err)"
                return
            }
            
            ref.downloadURL { url, err in
                if let err = err {
                    self.loginStatusMessage = "Error al descargar URL: \(err)"
                    return
                }
                
                //self.loginStatusMessage = "Imagen guardada exiotsamente con URL: \(url?.absoluteString ?? "")"
                self.loginStatusMessage = "Imagen guardada exiotsamente"
               // print(url?.absoluteString)
                
                guard let url = url else { return }
                self.storeUserInformation(imageProfileUrl: url)
            }
        }
    }
    
    // Aqui al momento de mandar email uid y profileImageUrl guardar en mysql de sebas aprovechando en la tabla usuarios
    
    private func storeUserInformation(imageProfileUrl: URL) {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        let userData = ["email": self.email, "uid": uid, "profileImageUrl": imageProfileUrl.absoluteString]
        FirebaseManager.shared.firestore.collection("users")
            .document(uid).setData(userData) { err in
                if let err = err {
                    print(err)
                    self.loginStatusMessage = "\(err)"
                    return
                }
                
                print("Success")
                
                self.didCompleteLoginProcess()
            }
    }
    
}

#Preview {
    LoginView(didCompleteLoginProcess:{
        
    })
        
}
