//
//  Colores.swift
//  StudyFlash
//
//  Created by Omar Martinez Lopez on 26/09/26.
//

import SwiftUI

extension Color{
    static let menta = Color(red: 0.53, green: 0.90, blue: 0.76) //#88E5C2
    static let coral = Color(red: 0.98, green: 0.55, blue: 0.47) //#FA8B78
    static let amarilloSuave = Color(red: 1.00, green: 0.90, blue: 0.58) //#FFE594
    static let lila = Color(red: 0.79, green: 0.71, blue: 0.89) //#C9B6E4
    static let correcto = Color(red: 0.30, green: 0.69, blue: 0.31) //#verde mas saturado, respuestas
    
}

struct FondoApp: View {
    var body: some View {
        LinearGradient(
            colors: [Color.menta.opacity(0.15), Color.amarilloSuave.opacity(0.12), Color.lila.opacity(0.12)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}

extension View {
    func conFondoApp() -> some View {
        self.background(FondoApp())
    }
}
