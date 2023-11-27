//
//  ChatUser.swift
//  MiPrimerTutorChat
//
//  Created by Irving Alejandro Vega Lagunas on 22/11/23.
//

import Foundation

import FirebaseFirestoreSwift

struct ChatUser: Codable, Identifiable {
    @DocumentID var id: String?
    let uid, email, profileImageUrl: String
}

