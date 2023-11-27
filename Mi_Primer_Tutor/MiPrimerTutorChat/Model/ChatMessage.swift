//
//  ChatMessage.swift
//  MiPrimerTutorChat
//
//  Created by Irving Alejandro Vega Lagunas on 27/11/23.
//

import Foundation
import FirebaseFirestoreSwift

struct ChatMessage: Codable, Identifiable {
    @DocumentID var id: String?
    let fromId, toId, text: String
    let timestamp: Date
}

