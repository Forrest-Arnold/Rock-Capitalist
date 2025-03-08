//
//  Gameplay_VM.swift
//  Rock-Capitalist
//
//  Created by Forrest Kalani Arnold on 3/7/25.
//

import Foundation

class Gameplay_VM: ObservableObject {
    
    @Published var playerRocks = [
        Rock(name: "Coal", value: 4, productionSpeed: 10, upgrade: Upgrade(maxAmount: 10, currentAmount: 1, oneCost: 10, tenCost: 100, fiftyCost: 500, hundredCost: 1000, maxCost: 99999), buyCost: 0),
        Rock(name: "Copper", value: 12, productionSpeed: 7, upgrade: Upgrade(maxAmount: 10, currentAmount: 1, oneCost: 10, tenCost: 100, fiftyCost: 500, hundredCost: 1000, maxCost: 99999), buyCost: 0),
        Rock(name: "Iron", value: 24, productionSpeed: 7, upgrade: Upgrade(maxAmount: 10, currentAmount: 1, oneCost: 10, tenCost: 100, fiftyCost: 500, hundredCost: 1000, maxCost: 99999), buyCost: 0),]
    
    
    
}
