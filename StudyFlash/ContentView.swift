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

                    ForEach(tarjetas.indices, id: \.self) { i in
                        VStack(alignment: .leading, spacing: 6) {
                            Text(tarjetas[i].pregunta).font(.headline)
                            Text(tarjetas[i].respuesta).foregroundStyle(.secondary)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(.blue.opacity(0.1), in: .rect(cornerRadius: 12))
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
