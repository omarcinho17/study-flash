//
//  Generador.swift
//  StudyFlash
//
//  Created by Omar Martinez Lopez on 18/09/26.
//

import FoundationModels

func generarTarjetas(de apuntes: String) async throws -> [Flashcard] {
    let sesion = LanguageModelSession(
        instructions: "Eres un tutor paciente. Creas flashcards en español, con lenguaje sencillo, para ayudar a alguien a quien le cuesta aprender."
    )
    let respuesta = try await sesion.respond(
        to: "Crea flashcards a partir de estos apuntes:\n\(apuntes)",
        generating: FlashcardSet.self
    )
    return respuesta.content.tarjetas
}
