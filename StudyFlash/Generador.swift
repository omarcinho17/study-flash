//
//  Generador.swift
//  StudyFlash
//
//  Created by Omar Martinez Lopez on 18/09/26.
//

import FoundationModels
import Foundation

func generarTarjetas(de apuntes: String, cantidad: Int) async throws -> [Flashcard]{
    let sesion = LanguageModelSession(
        instructions: "Eres un tutor paciente. Creas flashcards en español, con lenguaje sencillo, para ayudar a alguien a quien le cuesta aprender. Cada flashcard debe tratar un concepto DISTINTO de los apuntes, con una pregunta diferente a las demas. No repitas la misma pregunta con distinta redaccion. Da respuestas y explicaciones completas y utiles, no telegraficas: la persona debe poder aprender el concepto solo con leer la tarjeta, sin necesidad de volver a sus apuntes"
    )
    let respuesta = try await sesion.respond(
        to: "Crea exactamente \(cantidad) flashcards a partir de estos apuntes:\n\(apuntes)",
        generating: FlashcardSet.self
    )
    return Array(respuesta.content.tarjetas.prefix(cantidad))
}

func generarPregunta(de tarjeta: Flashcard) async throws -> PreguntaExamen {
    let sesion = LanguageModelSession(
        instructions: "Eres un profesor que prepara exámenes de opción múltiple sobre temas escolares. Escribes distractores: opciones plausibles pero equivocadas."
    )
    let respuesta = try await sesion.respond(
        to: "Tema de estudio. Pregunta: \(tarjeta.pregunta)\nRespuesta correcta: \(tarjeta.respuesta)\nEscribe 3 distractores para esta pregunta de examen.",
        generating: OpcionesIncorrectas.self
    )
    let incorrectas = respuesta.content.incorrectas.filter { $0 != tarjeta.respuesta }
    let opciones = (incorrectas + [tarjeta.respuesta]).shuffled()
    return PreguntaExamen(pregunta: tarjeta.pregunta, correcta: tarjeta.respuesta, opciones: opciones)
}

func generarExamen(de tarjetas: [Flashcard]) async throws -> [PreguntaExamen] {
    var preguntas: [PreguntaExamen] = []
    for tarjeta in tarjetas {
        if let pregunta = try? await generarPregunta(de: tarjeta) {
            preguntas.append(pregunta)
        }
    }
    if preguntas.isEmpty {
        throw NSError(domain: "StudyFlash", code: 1, userInfo: [
            NSLocalizedDescriptionKey: "No se pudo generar ninguna pregunta. Intenta con otros apuntes."
        ])
    }
    return preguntas
}


