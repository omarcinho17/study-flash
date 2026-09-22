//
//  PreguntaExamen.swift
//  StudyFlash
//
//  Created by Omar Martinez Lopez on 19/09/26.
//

import Foundation

struct PreguntaExamen: Identifiable {
    let id = UUID()
    let pregunta: String
    let correcta: String
    let opciones: [String]
}
