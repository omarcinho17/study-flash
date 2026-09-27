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
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: mostrarRespuesta ? "checkmark.circle.fill" : "questionmark.circle.fill")
                    .foregroundStyle(mostrarRespuesta ? Color.correcto : Color.menta)
                Text(mostrarRespuesta ? "RESPUESTA" : "PREGUNTA")
                    .font(.caption.bold())
                    .foregroundStyle(.secondary)
                Spacer()
            }

            VStack(spacing: 12) {
                Text(mostrarRespuesta ? tarjeta.respuesta : tarjeta.pregunta)
                    .font(.title2.bold())
                    .multilineTextAlignment(.center)

                if mostrarRespuesta {
                    Text(tarjeta.expliacion)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
            .frame(maxWidth: .infinity)

            Text(mostrarRespuesta ? "Toca para ver la pregunta" : "Toca para ver la respuesta")
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .padding(20)
        .frame(maxWidth: .infinity, minHeight: 260)
        .background(Color.menta.opacity(0.15), in: .rect(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.menta.opacity(0.4), lineWidth: 1)
        )
        .shadow(color: Color.menta.opacity(0.2), radius: 8, y: 4)
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.3)) {
                mostrarRespuesta.toggle()
            }
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


