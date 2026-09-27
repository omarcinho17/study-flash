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
    @State private var mostrandoEscaner = false
    @Environment(\.modelContext) private var contexto

    init(setInicial: SetDeEstudio? = nil) {
        if let setInicial {
            _tarjetas = State(initialValue: setInicial.tarjetas.map { $0.aFlashcard() })
            _apuntes = State(initialValue: setInicial.titulo)
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {

                    // Sección: apuntes
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Tus apuntes")
                            .font(.caption.bold())
                            .foregroundStyle(.secondary)

                        TextEditor(text: $apuntes)
                            .frame(height: 100)
                            .padding(8)
                            .background(.white.opacity(0.6), in: .rect(cornerRadius: 14))
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(.gray.opacity(0.2), lineWidth: 1)
                            )
                    }

                    // Sección: controles, en una sola línea compacta
                    HStack(spacing: 12) {
                        Stepper(value: $cantidad, in: 3...10) {
                            Text("\(cantidad) tarjetas")
                                .font(.subheadline)
                        }

                        Button {
                            Task { await crear() }
                        } label: {
                            Text(cargando ? "Generando..." : "Generar")
                                .font(.subheadline.bold())
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                        }
                        .buttonStyle(.borderedProminent)
                        .clipShape(.capsule)
                        .disabled(apuntes.isEmpty || cargando)
                    }

                    if let error {
                        Text(error)
                            .font(.caption)
                            .foregroundStyle(.red)
                    }

                    Divider()
                        .padding(.vertical, 4)

                    // Sección: la tarjeta, protagonista
                    if !tarjetas.isEmpty {
                        VStack(spacing: 16) {
                            Text("Tarjeta \(indiceActual + 1) de \(tarjetas.count)")
                                .font(.caption)
                                .foregroundStyle(.secondary)

                            TarjetaView(tarjeta: tarjetas[indiceActual])
                                .id(indiceActual)
                                .transition(.asymmetric(
                                    insertion: .move(edge: .trailing).combined(with: .opacity),
                                    removal: .move(edge: .leading).combined(with: .opacity)
                                ))

                            HStack(spacing: 12) {
                                Button {
                                    withAnimation(.easeInOut(duration: 0.3)) { indiceActual -= 1 }
                                } label: {
                                    Image(systemName: "chevron.left")
                                        .frame(width: 44, height: 44)
                                }
                                .buttonStyle(.bordered)
                                .clipShape(.circle)
                                .disabled(indiceActual == 0)

                                if indiceActual < tarjetas.count - 1 {
                                    Button {
                                        withAnimation(.easeInOut(duration: 0.3)) { indiceActual += 1 }
                                    } label: {
                                        Image(systemName: "chevron.right")
                                            .frame(width: 44, height: 44)
                                    }
                                    .buttonStyle(.bordered)
                                    .clipShape(.circle)
                                } else {
                                    Button(preparandoExamen ? "Preparando..." : "Hacer examen") {
                                        Task { await prepararExamen() }
                                    }
                                    .buttonStyle(.borderedProminent)
                                    .clipShape(.capsule)
                                    .tint(.green)
                                    .disabled(preparandoExamen)
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .sheet(isPresented: $mostrandoEscaner) {
                EscanerDocumentos { textoEscaneado in
                    apuntes = textoEscaneado
                }
            }
            .navigationTitle("StudyFlash")
            .fullScreenCover(isPresented: $enExamen) {
                ExamenView(preguntasIniciales: examen)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        mostrandoEscaner = true
                    } label: {
                        Image(systemName: "doc.viewfinder")
                    }
                }
                if !apuntes.isEmpty {
                    ToolbarItem(placement: .topBarLeading) {
                        NavigationLink {
                            ChatView(apuntes: apuntes)
                        } label: {
                            Image(systemName: "bubble.left.and.bubble.right")
                        }
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        ListaSetsView()
                    } label: {
                        Image(systemName: "folder")
                    }
                    .tint(.lila)
                }
            }
            .background(Color(red: 0.94, green: 0.98, blue: 0.96))
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
        let guardadas = tarjetas.map { TarjetaGuardada(pregunta: $0.pregunta, respuesta: $0.respuesta, expliacion: $0.expliacion) }
        let titulo = String(apuntes.prefix(30))
        let nuevoSet = SetDeEstudio(titulo: titulo, tarjetas: guardadas)
        contexto.insert(nuevoSet)
    }
}

#Preview {
    ContentView()
}
