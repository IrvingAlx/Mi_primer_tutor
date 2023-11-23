//
//  ChatLogView.swift
//  MiPrimerTutorChat
//
//  Created by Irving Alejandro Vega Lagunas on 22/11/23.
//

import SwiftUI

struct ChatLogView: View {
    let chatUser: ChatUser?
    
    @State private var emaili = ""
    @State var chatText = ""
    
    var body: some View {
        ZStack {
            messagesView
            VStack(spacing: 0) {
                Spacer()
                chatBottomBar
                    .background(Color.white.ignoresSafeArea())
            }
        }
        .onAppear {
            emaili = chatUser?.email.replacingOccurrences(of: "@gmail.com", with: "") ?? ""
        }
        .navigationTitle(emaili)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var messagesView: some View {
       ScrollView {
           ForEach(0..<20) { num in
               HStack {
                   Spacer()
                   HStack {
                       Text("UwU")
                           .foregroundColor(.white)
                   }
                   .padding()
                   .background(Color.blue)
                   .cornerRadius(8)
               }
               .padding(.horizontal)
               .padding(.top, 8)
           }
           
           HStack{ Spacer() }
           .frame(height: 50)
       }
       .background(Color(.init(white: 0.95, alpha: 1)))
                   
   }
   
   private var chatBottomBar: some View {
       HStack(spacing: 16) {
           Image(systemName: "photo.on.rectangle")
               .font(.system(size: 24))
               .foregroundColor(Color(.darkGray))
           ZStack {
               DescriptionPlaceholder()
               TextEditor(text: $chatText)
                   .opacity(chatText.isEmpty ? 0.5 : 1)
           }
           .frame(height: 40)
           
            Button {
               
            } label: {
                Text("Send")
                    .foregroundColor(.white)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color.blue)
            .cornerRadius(5)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}
private struct DescriptionPlaceholder: View {
   var body: some View {
       HStack {
           Text("Description")
               .foregroundColor(Color(.gray))
               .font(.system(size: 17))
               .padding(.leading, 5)
               .padding(.top, -4)
           Spacer()
       }
   }
}

#Preview {
    NavigationView {
        ChatLogView(chatUser: .init(data: ["uid":"pU4a7X9YwwWl2uuVqwcgdW8BfO33","email":"juan4@gmail.com"]))
    }
}