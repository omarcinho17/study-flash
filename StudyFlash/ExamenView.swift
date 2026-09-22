//
//  ExamenView.swift
//  StudyFlash
//
//  Created by Omar Martinez Lopez on 19/09/26.
//

import SwiftUI

struct ExamenView: View {
    let preguntas: [PreguntaExamen]
    @Environment(\.dismiss) private var dismiss

    @State private var indice = 0
    @State private var mostrarOpciones = false
    @State private var seleccionada: String?
    @State private var aciertos = 0
    @State private var terminado = false

    var preguntaActual: PreguntaExamen { preguntas[indice] }

    var body: some View {
        VStack(spacing: 20) {
            if terminado {
                resultados
            } else {
                Text("Pregunta \(indice + 1) de \(preguntas.count)  ·  ✅ \(aciertos)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Text(preguntaActual.pregunta)
                    .font(.title2.bold())
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, minHeight: 120)

                if mostrarOpciones {
                    ForEach(preguntaActual.opciones, id: \.self) { opcion in
                        Button {
                            elegir(opcion)
                        } label: {
                            Text(opcion)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                        }
                        .buttonStyle(.plain)
                        .background(color(para: opcion), in: .rect(cornerRadius: 12))
                    }
                } else {
                    Button("Siguiente") {
                        mostrarOpciones = true
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            Spacer()
        }
        .padding()
    }

    func color(para opcion: String) -> Color {
        guard let seleccionada else { return .gray.opacity(0.15) }
        if opcion == preguntaActual.correcta { return .green.opacity(0.6) }
        if opcion == seleccionada { return .red.opacity(0.6) }
        return .gray.opacity(0.15)
    }

    func elegir(_ opcion: String) {
        guard seleccionada == nil else { return }
        seleccionada = opcion
        if opcion == preguntaActual.correcta { aciertos += 1 }
        Task {
            try? await Task.sleep(for: .seconds(2))
            avanzar()
        }
    }

    func avanzar() {
        if indice < preguntas.count - 1 {
            indice += 1
            seleccionada = nil
            mostrarOpciones = false
        } else {
            terminado = true
        }
    }

    var resultados: some View {
        VStack(spacing: 16) {
            Text("Acertaste \(aciertos) de \(preguntas.count)")
                .font(.largeTitle.bold())
            Button("Cerrar") { dismiss() }
                .buttonStyle(.borderedProminent)
        }
        .padding(.top, 80)
    }
}

#Preview {
    ExamenView(preguntas: [
        PreguntaExamen(
            pregunta: "¿Qué es una API?",
            correcta: "Permite comunicación entre programas",
            opciones: ["Permite comunicación entre programas", "Un tipo de pantalla", "Un lenguaje de programación", "Un cable de red"]
        )
    ])
}


