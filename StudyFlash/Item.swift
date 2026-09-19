//
//  Item.swift
//  StudyFlash
//
//  Created by Omar Martinez Lopez on 18/09/26.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
