//
//  ContentView.swift
//  StudyFlash
//
//  Created by Omar Martinez Lopez on 18/09/26.
//

import SwiftUI

struct ContentView: View {
    @State private var apuntes = ""
    @State private var tarjetas: [Flashcard] = []
    @State private var cargando = false
    @State private var error: String?
    @State private var indiceAcutual = 0
    @State private var estudiando = false
    @State private var acertadas = 0
    @State private var noAcertadas = 0

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    TextEditor(text: $apuntes)
                        .frame(height: 160)
                        .padding(8)
                        .background(.gray.opacity(0.15), in: .rect(cornerRadius: 12))

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
                        Text("Tarjeta \(indiceAcutual + 1) de \(tarjetas.count)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        TarjetaView(tarjeta: tarjetas[indiceAcutual])
                            .id(indiceAcutual)
                        
                        HStack(spacing: 12){
                            Button("No acerte"){
                                noAcertadas += 1
                                if indiceAcutual < tarjetas.count - 1{
                                    indiceAcutual += 1
                                }
                            }
                            .buttonStyle(.bordered)
                            .tint(.red)
                            
                            Button("Acerte"){
                                acertadas += 1
                                if indiceAcutual < tarjetas.count - 1{
                                    indiceAcutual += 1
                                }
                            }
                            .buttonStyle(.bordered)
                            .tint(.green)
                        }
                        
                        Text("😎 \(acertadas)    😑 \(noAcertadas)")
                            .font(.headline)
                    }
                }
                .padding()
            }
            .navigationTitle("StudyFlash")
        }
    }

    func crear() async {
        cargando = true
        error = nil
        indiceAcutual = 0
        acertadas = 0
        noAcertadas = 0
        do {
            tarjetas = try await generarTarjetas(de: apuntes)
        } catch {
            self.error = "No se pudo generar: \(error.localizedDescription)"
        }
        cargando = false
    }
}

#Preview {
    ContentView()
}
