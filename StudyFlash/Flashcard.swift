//
//  Flashcard.swift
//  StudyFlash
//
//  Created by Omar Martinez Lopez on 18/09/26.
//

import FoundationModels

@Generable
struct Flashcard{
    @Guide(description: "Una pregunta clara y corta sobre un concepto importante del texto")
    var pregunta: String
    
    @Guide(description: "La respuesta breve y correcta de la pregunta")
    var respuesta: String
    
}

@Generable
struct OpcionesIncorrectas {
    @Guide(description: "Tres respuestas incorrectas pero creíbles, de longitud parecida a la respuesta correcta", .count(3))
    var incorrectas: [String]
}

@Generable
struct FlashcardSet{
    @Guide(description: "Lista de flashcards para estudiar")
    var tarjetas: [Flashcard]
}

extension TarjetaGuardada{
    func aFlashcard() -> Flashcard{
        Flashcard(pregunta: pregunta, respuesta: respuesta)
    }
}
