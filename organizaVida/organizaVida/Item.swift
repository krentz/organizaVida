//
//  Item.swift
//  OrganizaVida
//
//  Created by Rafael Krentz on 30/03/25.
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
