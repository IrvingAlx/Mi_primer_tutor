//
//  ViewModel.swift
//  AI-Tutor
//
//  Created by Sebastian Castañeda on 23/11/23.
//

import Foundation
import SwiftOpenAI

final class ViewModel: ObservableObject{
    // Para poder desplegar los mensajes en ConversationView e indicarle a ChatGPT como debe de comportarse
    @Published var messages: [MessageChatGPT] = [
        .init(text: "Eres un asistente educativo para niños y niñas de 4 a 7 años con capacidad de responder preguntas de aprendizaje general, lengua española básica, inglés básico y aritmética básica. Cuando hagan preguntas fuera de estos parámetros responde con 'No tengo información'. Es necesario que tus respuestas sean breves y concisas, que tengan un tono alegre y juguetón apropiado para niños pequeños en el rango de edad establecido. ", role: .system), .init(text: "¡Hola! ¿En qué te puedo ayudar?", role: .assistant)]
    
    @Published var currentMessage: MessageChatGPT = .init(text: "", role:.assistant)
    // API secreto de OpenAI
    var openAI = SwiftOpenAI(apiKey: "")
    
    // Método para enviar propmt
    func send(message: String) async {
        
        // Parámetros para petición de HTTP, se limitan los tokens a 100 para que no sean respuestas muy largas
        let optionalParameters = ChatCompletionsOptionalParameters(temperature: 0.7, stream: true, maxTokens: 200)
        
        // Para que se ejecute en el hilo principal
        await MainActor.run{
            // Crear un solo mensaje con los streams que vayan llegando
            let myMessage = MessageChatGPT(text: message, role: .user)
            self.messages.append(myMessage)
            
            // Guardar mensaje de respuesta de ChatGPT en el arreglo de mensajes
            self.currentMessage = MessageChatGPT(text: "", role: .assistant)
            self.messages.append(self.currentMessage)
        }
        
        do {
            // Es necesario ajustar a la versión de ChatGPT que se está usando
            let stream = try await openAI.createChatCompletionsStream(model: .gpt3_5(.turbo), 
                                                                      messages: messages,
                                                                      optionalParameters: optionalParameters)
            
            for try await response in stream {
                print(response)
                await onReceive(newMessage: response)
            }
        } catch {
            print("Error: \(error)")
        }
    }
    
    // Método para completar los mensajes
    @MainActor
    private func onReceive(newMessage: ChatCompletionsStreamDataModel) {
        // Se van guardando los streams hasta que se llegue al mensaje de stop
        let lastMessage = newMessage.choices[0]
        guard lastMessage.finishReason == nil else {
            print("Finished streaming messages")
            return
        }
        
        guard let content = lastMessage.delta?.content else {
            print("Message with no content")
            return
        }
        
        // Se almacena todo en currentMessage para desplegar
        currentMessage.text = currentMessage.text + content
        messages[messages.count-1].text = currentMessage.text
    }
    
}
