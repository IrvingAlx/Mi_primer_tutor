//
//  MatematicasView.swift
//  MiPrimerTutorChat
//
//  Created by Irving Alejandro Vega Lagunas on 26/11/23.
//

import SwiftUI

struct MatematicasView: View {
    var body: some View {
        VStack{
            Text("Matematicas")
                .font(.system(size: 36, weight: .heavy, design: .rounded))
                .multilineTextAlignment(.center)
                .padding(20)
            HStack{
                Gauge(value: 4, in: 0...5) {
                    Text("Progreso")
                }
                .padding()
            }
            
            Image(systemName: "plus.slash.minus")
                .resizable()
                .scaledToFit()
                .imageScale(.medium)
                .cornerRadius(10)
                .padding()
                .foregroundStyle(.blue)
            
            HStack{
                Button("A)") {
                    
                }
                //NavigationLink("A)", destination: EspanolView())
                .font(.largeTitle)
                .tint(.blue)
                .padding()
                .buttonStyle(GrowingButton())
                    
                Button("B)") {
                    
                }
                .font(.largeTitle)
                .tint(.red)
                .padding()
                .buttonStyle(GrowingButton())
            }
                
            HStack{
                Button("C)") {
                    
                }
                .font(.largeTitle)
                .tint(.blue)
                .padding()
                .buttonStyle(GrowingButton())
                
                Button("D)") {
                    
                }
                .font(.largeTitle)
                .tint(.blue)
                .padding()
                .buttonStyle(GrowingButton())
            }
            HStack{
                Button("Aceptar") {
                    
                }
                .font(.largeTitle)
                .tint(.blue)
                .padding()
                .buttonStyle(GrowingButton())
            }
        }
    }
}

#Preview {
    MatematicasView()
}
