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
struct FlashcardSet{
    @Guide(description: "Lista de flashcards para estudiar", .count(5))
    var tarjetas: [Flashcard]
}
