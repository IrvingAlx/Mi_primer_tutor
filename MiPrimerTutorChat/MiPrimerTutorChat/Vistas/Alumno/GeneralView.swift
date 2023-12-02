//
//  GeneralView.swift
//  MiPrimerTutorChat
//
//  Created by Irving Alejandro Vega Lagunas on 26/11/23.
//

import SwiftUI

struct GeneralView: View {
    var body: some View {
        VStack{
            Text("General")
                .font(.system(size: 36, weight: .heavy, design: .rounded))
                .multilineTextAlignment(.center)
                .padding(20)
            HStack{
                Gauge(value: 5, in: 0...5) {
                    Text("Progreso")
                }
                .padding()
            }
            
            Image(.general3)
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
                .padding()
                .buttonStyle(AButton())
                    
                Button("B)") {
                    
                }
                .font(.largeTitle)
                .tint(.red)
                .padding()
                .buttonStyle(BButton())
            }
                
            HStack{
                Button("C)") {
                    
                }
                .font(.largeTitle)
                .tint(.blue)
                .padding()
                .buttonStyle(CButton())
                
                Button("D)") {
                    
                }
                .font(.largeTitle)
                .tint(.blue)
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
    GeneralView()
}
