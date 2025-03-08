//
//  Gameplay_VM.swift
//  Rock-Capitalist
//
//  Created by Forrest Kalani Arnold on 3/7/25.
//

import Foundation

class Gameplay_VM: ObservableObject {
    
    @Published var currency = Currency()
    
    // do some rad math shit to calculate how much an upgrade costs, make sure it is exponential
    // currentAmount is 0 when you dont own it and when you buy it, it will gain 1 to show it is bought
    @Published var playerRocks = [
        Rock(name: "Coal", value: 40, productionSpeed: 10, upgrade: Upgrade(maxAmount: 10, currentAmount: 1, oneCost: 10, tenCost: 100, fiftyCost: 500, hundredCost: 1000, maxCost: 99999), buyCost: 0, worker: Worker(cost: 200)),
        Rock(name: "Copper", value: 12, productionSpeed: 7, upgrade: Upgrade(maxAmount: 10, currentAmount: 0, oneCost: 10, tenCost: 100, fiftyCost: 500, hundredCost: 1000, maxCost: 99999), buyCost: 120, worker: Worker(cost: 20000)),
        Rock(name: "Iron", value: 30, productionSpeed: 5, upgrade: Upgrade(maxAmount: 10, currentAmount: 0, oneCost: 10, tenCost: 100, fiftyCost: 500, hundredCost: 1000, maxCost: 99999), buyCost: 800, worker: Worker(cost: 100000))]
    
    
    func produceButtonPressed(rock: Rock) {
        currency.cash += rock.value
    }
    
    func checkIfCanBuyRock(rock: Rock) {
        if let index = playerRocks.firstIndex(where: { $0.name == rock.name }) {
            if playerRocks[index].buyCost <= currency.cash {
                currency.cash -= playerRocks[index].buyCost
                playerRocks[index].upgrade.currentAmount += 1
            }
        }
    }
    
    func checkIfCanUpgrade(rock: Rock) {
        if let index = playerRocks.firstIndex(where: { $0.name == rock.name }) {
            if Float(playerRocks[index].upgrade.currentAmount) < Float(playerRocks[index].upgrade.maxAmount) {
                if playerRocks[index].upgrade.oneCost <= currency.cash {
                    currency.cash -= playerRocks[index].upgrade.oneCost
                    playerRocks[index].upgrade.currentAmount += 1
                    
                    // Update upgrade cost
                    playerRocks[index].upgrade.oneCost *= (1.0 + (Float(playerRocks[index].upgrade.currentAmount) / 10.0))
                    playerRocks[index].upgrade.oneCost = (playerRocks[index].upgrade.oneCost * 1000).rounded() / 1000
                    
                    // Update only this rock's value
                    playerRocks[index].value *= 1 + (Float(playerRocks[index].upgrade.currentAmount) / 35.0)
                    playerRocks[index].value = (playerRocks[index].value * 1000).rounded() / 1000
                }
            }
        }
    }

    
    func updateAllRockValues() {
        for index in playerRocks.indices {
            playerRocks[index].value *= 1 + (Float(playerRocks[index].upgrade.currentAmount) / 15.0)
            playerRocks[index].value = (playerRocks[index].value * 1000).rounded() / 1000
        }
    }
    
    func checkIfHasWorker(rock: Rock) -> Bool {
        if rock.worker.isBought {
            // If true return the boolean so the timer can start
            // then connect the timer to the percent of the progress bar
            return true
        } else {
            // If false return the boolean then check if you have enough money to buy the worker
            if currency.cash >= rock.worker.cost {
                currency.cash -= rock.worker.cost
                return true
            } else {
                return false
            }
        }
    }
}
