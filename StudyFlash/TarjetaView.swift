//
//  TarjetaView.swift
//  StudyFlash
//
//  Created by Omar Martinez Lopez on 19/09/26.
//

import SwiftUI

struct TarjetaView: View {
    let tarjeta: Flashcard
    @State private var mostrarRespuesta = false
    
    var body: some View{
        Text(mostrarRespuesta ? tarjeta.respuesta: tarjeta.pregunta)
            .font(.title2)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity, minHeight: 250)
            .padding()
            .background(.blue.opacity(0.1), in: .rect(cornerRadius: 20))
            .onTapGesture {
                mostrarRespuesta.toggle()
            }
    }
}

#Preview {
    TarjetaView(tarjeta: Flashcard(
        pregunta: "que es la fotosintesis?",
        respuesta: "Es el proceso con el que las plantas convierten luz en energia"
    ))
}


