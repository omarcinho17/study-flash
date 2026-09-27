//
//  MensajeChat.swift
//  StudyFlash
//
//  Created by Omar Martinez Lopez on 26/09/26.
//

import Foundation

struct MensajeChat: Identifiable{
    let id = UUID()
    let texto: String
    let esDeUsuario: Bool
}
