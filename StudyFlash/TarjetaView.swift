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
        VStack(spacing: 12){
            Text(mostrarRespuesta ? tarjeta.respuesta: tarjeta.pregunta)
                .font(.title2)
                .multilineTextAlignment(.center)
            
            if mostrarRespuesta{
                Text(tarjeta.expliacion)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity, minHeight: 250)
        .fixedSize(horizontal: false, vertical: true)
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
        respuesta: "Es el proceso con el que las plantas convierten luz en energia",
        expliacion: "Es como si la planta  comiera usando el sol en vez de masticar comida"
    ))
}


