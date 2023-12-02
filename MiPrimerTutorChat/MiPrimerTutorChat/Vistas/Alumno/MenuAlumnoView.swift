//
//  MenuAlumnoView.swift
//  MiPrimerTutorChat
//
//  Created by Irving Alejandro Vega Lagunas on 26/11/23.
//

import SwiftUI

struct MenuAlumnoView: View {
    
    var idAlumno: Int

    
    var body: some View {
        VStack{
            Text("Menu Alumnos")
                .font(.system(size: 36, weight: .heavy, design: .rounded))
                .multilineTextAlignment(.center)
                .padding(50)
                
            Image(systemName: "graduationcap.fill")
                .resizable()
                .scaledToFit()
                .imageScale(.medium)
                .cornerRadius(10)
                .padding()
                .foregroundStyle(.blue)
            
            HStack{
                NavigationLink("Español", destination: EspanolView())
                    .font(.system(size: 21, weight: .semibold))
                    .font(.largeTitle)
                    .tint(.blue)
                    .padding()
                    .buttonStyle(GrowingButton())
                
                    
                NavigationLink("Inglés", destination: InglesView())
                    .font(.system(size: 21, weight: .semibold))
                    .tint(.red)
                    .padding()
                    .buttonStyle(GrowingButton())
            }
                
            HStack{
                NavigationLink("Matematicas", destination: MatematicasView())
                    .font(.system(size: 21, weight: .semibold))
                    .tint(.red)
                    .padding()
                    .buttonStyle(GrowingButton())
                
                NavigationLink("General", destination: GeneralView())
                    .font(.system(size: 21, weight: .semibold))
                    .tint(.red)
                    .padding()
                    .buttonStyle(GrowingButton())
            }
            HStack{
                NavigationLink("Tutor", destination: TutorView())
                    .font(.system(size: 21, weight: .semibold))
                    .tint(.red)
                    .padding()
                    .buttonStyle(GrowingButton())
            }
            NavigationLink("Salir", destination: ContentView())
                .font(.system(size: 21, weight: .semibold))
                .tint(.red)
                .buttonStyle(GrowingButton())
                .navigationBarBackButtonHidden(true)
                .frame(width: 360)
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    MenuAlumnoView(idAlumno: 1)
}
