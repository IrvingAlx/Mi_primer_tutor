//
//  InglesView.swift
//  MiPrimerTutorChat
//
//  Created by Irving Alejandro Vega Lagunas on 26/11/23.
//

import SwiftUI

struct InglesView: View {
    var body: some View {
        VStack{
            Text("Inglés")
                .font(.system(size: 36, weight: .heavy, design: .rounded))
                .multilineTextAlignment(.center)
                .padding(20)
            HStack{
                Gauge(value: 2, in: 0...5) {
                    Text("Progreso")
                }
                .padding()
            }
            
            Image(.ingles1)
                .resizable()
                .scaledToFit()
                .imageScale(.medium)
                .cornerRadius(10)
                .foregroundStyle(.blue)
            
            HStack{
                Button("A)") {
                    
                }
                //NavigationLink("A)", destination: EspanolView())
                .font(.largeTitle)
                .padding()
                .buttonStyle(AButton())
                    
                Button("B)") {
                    
                }
                .font(.largeTitle)
                .padding()
                .buttonStyle(BButton())
            }
                
            HStack{
                Button("C)") {
                    
                }
                .font(.largeTitle)
                .padding()
                .buttonStyle(CButton())
                
                Button("D)") {
                    
                }
                .font(.largeTitle)
                .padding()
                .buttonStyle(DButton())
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
    InglesView()
}
