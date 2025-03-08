//
//  Rock.swift
//  Rock-Capitalist
//
//  Created by Forrest Kalani Arnold on 3/7/25.
//

import Foundation

struct Rock: Identifiable {
    var id = UUID()
    let name: String
    var value: Float
    var productionSpeed: Float
    var upgrade: Upgrade
    let buyCost: Float
    var worker: Worker
}
