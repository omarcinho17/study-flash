//
//  SetDeEstudio.swift
//  StudyFlash
//
//  Created by Omar Martinez Lopez on 22/09/26.
//

import Foundation
import SwiftData

@Model
class SetDeEstudio{
    var titulo: String
    var fecha: Date
    var tarjetas: [TarjetaGuardada]
    
    init(titulo: String, tarjetas: [TarjetaGuardada]) {
            self.titulo = titulo
            self.fecha = .now
            self.tarjetas = tarjetas
        }
    }

    struct TarjetaGuardada: Codable {
        var pregunta: String
        var respuesta: String
    }

