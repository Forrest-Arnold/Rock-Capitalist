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
    var value: Int
    var productionSpeed: Int
    let upgrade: Upgrade
    let buyCost: Int
}
