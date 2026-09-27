//
//  ChatView.swift
//  StudyFlash
//
//  Created by Omar Martinez Lopez on 26/09/26.
//

import SwiftUI
import FoundationModels

struct ChatView: View {
    let apuntes: String

    @State private var mensajes: [MensajeChat] = []
    @State private var preguntaActual = ""
    @State private var cargando = false
    @State private var sesion: LanguageModelSession?

    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(mensajes) { mensaje in
                        Text(mensaje.texto)
                            .padding()
                            .background(mensaje.esDeUsuario ? Color.blue.opacity(0.2) : Color.gray.opacity(0.15), in: .rect(cornerRadius: 12))
                            .frame(maxWidth: .infinity, alignment: mensaje.esDeUsuario ? .trailing : .leading)
                    }
                    if cargando {
                        ProgressView()
                    }
                }
                .padding()
            }

            HStack {
                TextField("Pregunta algo sobre tus apuntes...", text: $preguntaActual)
                    .textFieldStyle(.roundedBorder)
                Button("Enviar") {
                    Task { await preguntar() }
                }
                .disabled(preguntaActual.isEmpty || cargando)
            }
            .padding()
        }
        .navigationTitle("Pregúntale a tus apuntes")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(red: 0.94, green: 0.98, blue: 0.96))
    }

    func iniciarSesion() {
        sesion = LanguageModelSession(
            instructions: "Eres un tutor conversacional y amigable. El estudiante está viendo estos apuntes:\n\(apuntes)\n\nPuedes responder preguntas sobre esos apuntes, pero también puedes responder preguntas relacionadas aunque no estén escritas ahí, usando tu conocimiento general para ayudarle a entender mejor el tema. Si te pregunta algo totalmente distinto al tema de los apuntes, respóndele de todas formas de forma útil. Responde en español, claro y no muy largo."
        )
    }

    func preguntar() async {
        if sesion == nil { iniciarSesion() }
        guard let sesion else { return }

        let textoPregunta = preguntaActual
        mensajes.append(MensajeChat(texto: textoPregunta, esDeUsuario: true))
        preguntaActual = ""
        cargando = true
        do {
            let respuesta = try await sesion.respond(to: textoPregunta)
            mensajes.append(MensajeChat(texto: respuesta.content, esDeUsuario: false))
        } catch {
            mensajes.append(MensajeChat(texto: "No pude responder eso.", esDeUsuario: false))
        }
        cargando = false
    }
}

#Preview {
    NavigationStack {
        ChatView(apuntes: "La fotosíntesis es el proceso con el que las plantas convierten luz en energía.")
    }
}
