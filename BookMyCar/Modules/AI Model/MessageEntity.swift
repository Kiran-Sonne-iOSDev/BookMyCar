//
//  MessageEntity.swift
//  Assignment1
//
//  Created by Kiran Sonne on 12/02/25.
//

import Foundation
import SwiftUI
struct Message: Identifiable {
    let id = UUID()
    let content: String
    let sender: String
}
