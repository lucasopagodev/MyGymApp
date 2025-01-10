//
//  Item.swift
//  MyGymDay
//
//  Created by Lucas Rodrigues on 09/01/25.
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