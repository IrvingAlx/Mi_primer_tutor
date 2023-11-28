//
//  TutorView.swift
//  MiPrimerTutorChat
//
//  Created by Sebastian Castañeda on 23/11/23.
//

import SwiftUI

struct TutorView: View {
    @StateObject var viewModel = ViewModel()
    @State var prompt: String = ""
    @State var useButton: Bool = false
    
    var body: some View {
        VStack {
            Text("Tutor IA")
                .padding(.horizontal, 50)
                .font(.system(size: 30, weight: .heavy, design: .default))
            
            ConversationView()
                .environmentObject(viewModel)
                .padding(.horizontal, 12)
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            Spacer()
            HStack {
                TextField("¡Pregunta lo que necesites!", text: $prompt, axis: .vertical)
                    .padding(12)
                    .background(Color(.systemGray6))
                    .cornerRadius(25)
                    .lineLimit(6)
                Button(action: {
                    Task {
                        // Validación extra para desactivar el botón en lo que se obtiene respuesta
                        useButton = true
                        await viewModel.send(message: prompt)
                        useButton = false
                        prompt = ""
                    }
                }){
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(Color.white)
                        .frame(width: 44, height: 44)
                        .background(Color.blue)
                        .cornerRadius(22)
                }
            }
            .padding(.leading, 8)
            .disabled(useButton)
        }
        .padding()
    }
}

#Preview {
    TutorView()
}
