//
//  StudyFlashApp.swift
//  StudyFlash
//
//  Created by Omar Martinez Lopez on 19/09/26.
//

import SwiftUI
import SwiftData

@main
struct StudyFlashApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .tint(.menta)
                .preferredColorScheme(.light)
        }
        .modelContainer(for: SetDeEstudio.self)
    }
}


