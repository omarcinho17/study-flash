//
//  ListaSetView.swift
//  StudyFlash
//
//  Created by Omar Martinez Lopez on 23/09/26.
//

import SwiftUI
import SwiftData

struct ListaSetsView: View {
    @Query(sort: \SetDeEstudio.fecha, order: .reverse) var sets: [SetDeEstudio]
    @Environment(\.modelContext) private var contexto

    var body: some View {
        List {
            ForEach(sets) { set in
                NavigationLink {
                    ContentView(setInicial: set)
                } label: {
                    HStack(spacing: 14) {
                        Image(systemName: "rectangle.stack.fill")
                            .font(.title2)
                            .foregroundStyle(Color.menta)
                            .frame(width: 40)

                        VStack(alignment: .leading, spacing: 4) {
                            Text(set.titulo)
                                .font(.headline)
                            Text(set.fecha.formatted(date: .abbreviated, time: .shortened))
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 6)
                }
                .listRowBackground(Color.white.opacity(0.6))
            }
            .onDelete(perform: borrar)
        }
        .navigationTitle("Mis sets")
    }

    func borrar(en offsets: IndexSet) {
        for indice in offsets {
            contexto.delete(sets[indice])
        }
    }
    
}

#Preview {
    NavigationStack {
        ListaSetsView()
    }
    .modelContainer(for: SetDeEstudio.self, inMemory: true)
}
