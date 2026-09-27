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
    @State private var mensajesChat: [MensajeChat] = []
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
                    VStack(spacing: 16) {
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

                        HStack(spacing: 12) {
                            HStack(spacing: 8){
                                ForEach([3, 5, 8, 10], id: \.self){ numero in
                                    Button{
                                        cantidad = numero
                                    } label:{
                                        Text("\(numero)")
                                            .font(.subheadline.bold())
                                            .frame(width: 20, height: 25)
                                    }
                                    .buttonStyle(.bordered)
                                    .tint(cantidad == numero ? .menta: .gray)
                                    .background(cantidad == numero ? Color.menta.opacity(0.2): .clear, in: .circle)
                                }
                            }
                            Button {
                                Task { await crear() }
                            } label: {
                                Label(cargando ? "Generando..." : "Generar", systemImage: "sparkles")
                                    .font(.subheadline.bold())
                                    .padding(.horizontal, 7)
                                    .padding(.vertical, 6)
                            }
                            .buttonStyle(.borderedProminent)
                            .clipShape(.capsule)
                            .disabled(apuntes.isEmpty || cargando)
                        }
                    }
                    .padding(16)
                    .background(.white.opacity(0.4), in: .rect(cornerRadius: 20))

                    if let error {
                        Text(error)
                            .font(.caption)
                            .foregroundStyle(.red)
                    }
                    if tarjetas.isEmpty{
                        VStack(spacing: 12){
                            Text("Selecciona cuantas flashcards deseas")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Image(systemName: "sparkles.rectangle.stack")
                                .font(.system(size: 40))
                                .foregroundStyle(Color.menta)
                            Text("Escribe o escanea tus apuntes para empezar")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 30)
                    }

                    Divider()
                        .padding(.vertical, 4)

                    if !tarjetas.isEmpty {
                        VStack(spacing: 16) {
                            HStack(spacing: 6) {
                                ForEach(0..<tarjetas.count, id: \.self) { i in
                                    Capsule()
                                        .fill(i == indiceActual ? Color.menta : Color.gray.opacity(0.25))
                                        .frame(width: i == indiceActual ? 20 : 6, height: 6)
                                        .animation(.easeInOut, value: indiceActual)
                                }
                            }
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
                                    Button(preparandoExamen ? "Preparando..." : "Hacer evaluacion") {
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
                            ChatView(apuntes: apuntes, mensajes: $mensajesChat)
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
        mensajesChat = []
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
