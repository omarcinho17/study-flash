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
    
    @Guide(description: "La respuesta correcta, completa en 1 o 2 oraciones, no solo una palabra o frase muy corta")
    var respuesta: String
    
    @Guide(description: "Una explicacion de 2 a 4 oraciones, en lenguaje sencillo, que profundice el porque de la respuesta, agregue contexto y de un ejemplo de la vida diaria")
    var expliacion: String
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
        Flashcard(pregunta: pregunta, respuesta: respuesta, expliacion: expliacion)
    }
}
