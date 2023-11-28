//
//  ConversationView.swift
//  AI-Tutor
//
//  Created by Sebastian Castañeda on 23/11/23.
//

import SwiftUI

struct ConversationView: View {
    @EnvironmentObject var viewModel: ViewModel
    var body: some View {
    // Que se vaya al último mensaje automáticamente
        ScrollViewReader { proxy in
            // Enlistar todos los mensajes que vayan generando
            ScrollView {
                ForEach(viewModel.messages, id:\.id) { message in
                    TextMessageView(message: message)
                }
                // Para lograr que se haga auto scroll conforme se recibe mensaje
                .onChange(of: viewModel.messages, perform: { newMessages in
                    if let lastMessage = newMessages.last {
                        withAnimation {
                            proxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                })
            }
        }
    }
}

#Preview {
    ConversationView().environmentObject(ViewModel())
}
