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
                VStack(alignment: .leading) {
                    Text(set.titulo)
                        .font(.headline)
                    Text(set.fecha.formatted(date: .abbreviated, time: .shortened))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
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
