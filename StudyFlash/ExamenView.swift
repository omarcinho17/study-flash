//
//  ExamenView.swift
//  StudyFlash
//
//  Created by Omar Martinez Lopez on 19/09/26.
//

import SwiftUI

struct ExamenView: View {
    let preguntasIniciales: [PreguntaExamen]
    @State private var preguntas: [PreguntaExamen] = []
    init(preguntasIniciales: [PreguntaExamen]) {
        self.preguntasIniciales = preguntasIniciales
        _preguntas = State(initialValue: preguntasIniciales)
    }
    @Environment(\.dismiss) private var dismiss

    @State private var indice = 0
    @State private var mostrarOpciones = false
    @State private var seleccionada: String?
    @State private var aciertos = 0
    @State private var falladas: [PreguntaExamen] = []
    @State private var terminado = false

    var preguntaActual: PreguntaExamen { preguntas[indice] }

    var body: some View {
        VStack(spacing: 20) {
            if terminado {
                resultados
            } else {
                HStack{
                    ProgressView(value: Double(indice), total: Double(preguntas.count))
                        .tint(.menta)
                    Label("\(indice + 1) de \(preguntas.count)", systemImage: "doc.text")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Label("\(aciertos)", systemImage: "checkmark.circle.fill")
                        .font(.subheadline.bold())
                        .foregroundStyle(Color.correcto)
                }
                
                Text(preguntaActual.pregunta)
                    .font(.title2.bold())
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, minHeight: 120)
                    .id(indice)
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))
                if mostrarOpciones {
                    VStack(spacing: 10) {
                        ForEach(preguntaActual.opciones, id: \.self) { opcion in
                            Button {
                                elegir(opcion)
                            } label: {
                                HStack {
                                    Text(opcion)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    if seleccionada != nil {
                                        if opcion == preguntaActual.correcta {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundStyle(.white)
                                        } else if opcion == seleccionada {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundStyle(.white)
                                        }
                                    }
                                }
                                .padding()
                            }
                            .buttonStyle(.plain)
                            .background(color(para: opcion), in: .rect(cornerRadius: 12))
                            .scaleEffect(seleccionada == opcion ? 1.06 : 1.0)
                            .animation(.spring(response: 0.3, dampingFraction: 0.4), value: seleccionada)
                        }
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
        .background(Color(red: 0.94, green: 0.98, blue: 0.96))
    }
    
    func color(para opcion: String) -> Color {
        guard let seleccionada else { return .gray.opacity(0.12) }
        if opcion == preguntaActual.correcta { return .correcto.opacity(0.7) }
        if opcion == seleccionada { return .coral.opacity(0.7) }
        return .gray.opacity(0.12)
    }
    
    func elegir(_ opcion: String) {
        guard seleccionada == nil else { return }
        seleccionada = opcion
        if opcion == preguntaActual.correcta{
            aciertos += 1
        } else{
            falladas.append(preguntaActual)
        }
        Task {
            try? await Task.sleep(for: .seconds(2))
            avanzar()
        }
    }

    func avanzar() {
        withAnimation(.easeInOut(duration: 0.3)){
            if indice < preguntas.count - 1 {
                indice += 1
                seleccionada = nil
                mostrarOpciones = false
            } else {
                terminado = true
            }
        }
    }
    func reiniciar(con nuevas: [PreguntaExamen]) {
        preguntas = nuevas
        indice = 0
        seleccionada = nil
        mostrarOpciones = false
        aciertos = 0
        falladas = []
        terminado = false
    }

    var resultados: some View {
        ZStack{
            Color(red: 0.94, green: 0.98, blue: 0.96)
                    .ignoresSafeArea()
            VStack(spacing: 20) {
                Image(systemName: aciertos == preguntas.count ? "star.fill" : "checkmark.circle.fill")
                    .font(.system(size: 50))
                    .foregroundStyle(Color.correcto)
                
                Text("Acertaste \(aciertos) de \(preguntas.count)")
                    .font(.largeTitle.bold())
                
                if !falladas.isEmpty {
                    Button("Repasar las que fallé") {
                        reiniciar(con: falladas)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.coral)
                    .clipShape(.capsule)
                }
                
                Button("Cerrar") { dismiss() }
                    .buttonStyle(.bordered)
                    .tint(.menta)
                    .clipShape(.capsule)
            }
            .padding(.top, 80)
            
        }
    }
    
}

#Preview {
    ExamenView(preguntasIniciales:[
        PreguntaExamen(
            pregunta: "¿Qué es una API?",
            correcta: "Permite comunicación entre programas",
            opciones: ["Permite comunicación entre programas", "Un tipo de pantalla", "Un lenguaje de programación", "Un cable de red"]
        )
    ])
}


