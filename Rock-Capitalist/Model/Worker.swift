//
//  Worker.swift
//  Rock-Capitalist
//
//  Created by Forrest Kalani Arnold on 3/7/25.
//

import Foundation

struct Worker: Identifiable {
    var id = UUID()
    let cost: Float
    var isBought = false
}
