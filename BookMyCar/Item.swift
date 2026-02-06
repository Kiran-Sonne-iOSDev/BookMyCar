//
//  Item.swift
//  BookMyCar
//
//  Created by Kiran Sonne on 06/02/26.
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
