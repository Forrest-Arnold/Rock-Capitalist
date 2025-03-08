//
//  Upgrade.swift
//  Rock-Capitalist
//
//  Created by Forrest Kalani Arnold on 3/7/25.
//

import Foundation

struct Upgrade: Identifiable {
    var id = UUID()
    var maxLevel = 1
    var maxAmount: Int
    var currentAmount: Int
    var oneCost: Float
    var tenCost: Float
    var fiftyCost: Float
    var hundredCost: Float
    var maxCost: Float
}
