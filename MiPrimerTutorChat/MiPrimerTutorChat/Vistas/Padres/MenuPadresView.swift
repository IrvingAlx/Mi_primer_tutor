//
//  MenuPadresView.swift
//  MiPrimerTutorChat
//
//  Created by Irving Alejandro Vega Lagunas on 26/11/23.
//

import SwiftUI

struct MenuPadresView: View {
    @State var shouldShowLogOutOptions = false
    @ObservedObject private var vm = MainMessagesViewModel()


    var body: some View {
        VStack{
            Text("Menu Padres")
                .font(.system(size: 36, weight: .heavy, design: .rounded))
                .multilineTextAlignment(.center)
                .padding(20)
                
            Image(systemName: "rectangle.stack.person.crop")
                .resizable()
                .scaledToFit()
                .imageScale(.medium)
                .cornerRadius(10)
                .foregroundStyle(.blue)
            
            VStack {
                HStack{
                    NavigationLink("Progreso Alumno", destination: ProgresoAlumnoView())
                        .font(.title)
                        .padding()
                        .buttonStyle(GrowingButton())
                    
                }
                HStack{
                    NavigationLink("Puntaje Alumnos", destination: PuntajeAlumnoView())
                        .font(.title)
                        .padding()
                        .buttonStyle(GrowingButton())

                }
                HStack{
                    NavigationLink("Alta", destination: AltaAlumunoView())
                        .font(.title)
                        .padding()
                        .buttonStyle(GrowingButton())
                
                    NavigationLink("Chat", destination: MainMessagesView())
                        .font(.title)
                        .padding()
                        .buttonStyle(GrowingButton())
                }
                HStack {
                    Button("Salir") {
                        shouldShowLogOutOptions.toggle()
                    }
                    .font(.title)
                    .padding()
                    .buttonStyle(GrowingButton())
                }
                .padding()
                .actionSheet(isPresented: $shouldShowLogOutOptions) {
                    .init(title: Text("Ajustes"), message: Text("Que quieres hacer?"), buttons: [
                        .destructive(Text("Sign Out"), action: {
                            print("handle sign out")
                            vm.handleSignOut()
                        }),
                            .cancel()
                    ])
                }
                .fullScreenCover(isPresented: $vm.isUserCurrentlyLoggedOut, onDismiss: nil){
                    LoginView(didCompleteLoginProcess: { userType in
                            self.vm.isUserCurrentlyLoggedOut = false
                            self.vm.fetchCurrentUser()
                            
                            switch userType {
                            case .professor:
                                // Lógica específica para cuando el usuario es un profesor
                                break
                            case .parent:
                                // Lógica específica para cuando el usuario es un padre
                                break
                            }
                        }, userType: .parent) // Pasa el valor correspondiente
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    MenuPadresView()
}
