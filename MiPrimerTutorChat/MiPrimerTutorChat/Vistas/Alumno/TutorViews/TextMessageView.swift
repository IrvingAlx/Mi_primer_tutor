//
//  TextMessageView.swift
//  AI-Tutor
//
//  Created by Sebastian Castañeda on 23/11/23.
//

import SwiftUI
import SwiftOpenAI

// Vista para determinar la apariencia de los mensajes entre Tutor y Alumno
struct TextMessageView: View {
    var message: MessageChatGPT
    
    var body: some View {
        HStack {
            // Se dejan fuera los mensajes de tipo sistema para evitar que se muestren las instrucciones iniciales del tutor
            // Formato para mensajes con identificador de usuario
            if message.role == .user {
                Spacer()
                Text(message.text)
                    .multilineTextAlignment(.trailing)
                    .foregroundColor(.white)
                    .padding(.all, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.blue)
                    )
                    .frame(maxWidth: 240, alignment: .trailing)
                
            } else {
                // Formato para mensajes con identificador de asistente
                if message.role == .assistant{
                    Text(message.text)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.white)
                        .padding(.all, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.gray)
                        )
                        .frame(maxWidth: 240, alignment: .leading)
                    Spacer()
                }
            }
        }
    }
    
    struct TextMessageView_Previews: PreviewProvider {
        // Mensajes de prueba para poder modificar las vistas
        static let chatGPTMessage: MessageChatGPT = .init(text: "¡Hola! Soy tu tutor. Pregúntame lo que necesites.", role: .system)
        static let myMessage: MessageChatGPT = .init(text: "¿Cómo se dice gallina en inglés?", role: .user)
        static var previews: some View {
            Group {
                TextMessageView(message: Self.chatGPTMessage)
                    .previewDisplayName("ChatGPT Message")
                TextMessageView(message: Self.myMessage)
                    .previewDisplayName("My Message")
            }.previewLayout(.sizeThatFits)
        }
    }
}
