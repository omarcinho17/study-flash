//
//  ContentView.swift
//  StudyFlash
//
//  Created by Omar Martinez Lopez on 18/09/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var apuntes = ""
    @State private var tarjetas: [Flashcard] = []
    @State private var cargando = false
    @State private var error: String?
    @State private var indiceActual = 0
    @State private var estudiando = false
    @State private var cantidad = 5
    @State private var enExamen = false
    @State private var examen: [PreguntaExamen] = []
    @State private var preparandoExamen = false
    @Environment(\.modelContext) private var contexto

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    TextEditor(text: $apuntes)
                        .frame(height: 160)
                        .padding(8)
                        .background(.gray.opacity(0.20), in: .rect(cornerRadius: 12))
                    Stepper("Cantidad: \(cantidad)", value: $cantidad, in: 3...10)

                    Button {
                        Task { await crear() }
                    } label: {
                        Text(cargando ? "Generando..." : "Crear flashcards")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(apuntes.isEmpty || cargando)

                    if let error {
                        Text(error).foregroundStyle(.red)
                    }

                    if !tarjetas.isEmpty{
                        Text("Tarjeta \(indiceActual + 1) de \(tarjetas.count)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        TarjetaView(tarjeta: tarjetas[indiceActual])
                            .id(indiceActual)
                    }
                    
                    HStack(spacing: 12) {
                        Button("Anterior") {
                            indiceActual -= 1
                        }
                        .buttonStyle(.bordered)
                        .disabled(indiceActual == 0)

                        if indiceActual < tarjetas.count - 1 {
                            Button("Siguiente") {
                                indiceActual += 1
                            }
                            .buttonStyle(.borderedProminent)
                        } else {
                            Button(preparandoExamen ? "Preparando..." : "Hacer Evaluacion") {
                                Task { await prepararExamen() }
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.green)
                            .disabled(preparandoExamen)
                        }
                    }
                    
                }
                .padding()
            }
            .navigationTitle("StudyFlash")
            .fullScreenCover(isPresented: $enExamen){
                ExamenView(preguntasIniciales: examen)
            }
        }
    }

    func crear() async {
        cargando = true
        error = nil
        indiceActual = 0
        do {
            tarjetas = try await generarTarjetas(de: apuntes, cantidad: cantidad)
            guardarSet()
        } catch {
            self.error = "No se pudo generar: \(error.localizedDescription)"
        }
        cargando = false
    }
    
    func prepararExamen() async {
        preparandoExamen = true
        do {
            examen = try await generarExamen(de: tarjetas)
            enExamen = true
        } catch {
            self.error = "No se pudo preparar el examen: \(error.localizedDescription)"
        }
        preparandoExamen = false
    }
    
    func guardarSet() {
        let guardadas = tarjetas.map { TarjetaGuardada(pregunta: $0.pregunta, respuesta: $0.respuesta) }
        let titulo = String(apuntes.prefix(30))
        let nuevoSet = SetDeEstudio(titulo: titulo, tarjetas: guardadas)
        contexto.insert(nuevoSet)
    }
}

#Preview {
    ContentView()
}
