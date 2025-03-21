//
//  Gameplay_VM.swift
//  Rock-Capitalist
//
//  Created by Forrest Kalani Arnold on 3/7/25.
//

import Foundation

class Gameplay_VM: ObservableObject {
    
    @Published var currency = Currency()
    
    @Published var counterDict: [String: Double] = [:] // Stores separate counters for each rock
    
    var timers: [String: Timer] = [:] // Dictionary to store timers per rock
    
    // do some rad math shit to calculate how much an upgrade costs, make sure it is exponential
    // currentAmount is 0 when you dont own it and when you buy it, it will gain 1 to show it is bought
    @Published var playerRocks = [
        Rock(name: "Coal", value: 4, productionSpeed: 1.2, upgrade: Upgrade(maxAmount: 10, currentAmount: 1, oneCost: 10, tenCost: 100, fiftyCost: 500, hundredCost: 1000, maxCost: 99999), buyCost: 0, worker: Worker(cost: 200)),
        Rock(name: "Copper", value: 50, productionSpeed: 0.8, upgrade: Upgrade(maxAmount: 10, currentAmount: 0, oneCost: 80, tenCost: 100, fiftyCost: 500, hundredCost: 1000, maxCost: 99999), buyCost: 120, worker: Worker(cost: 20000)),
        Rock(name: "Iron", value: 300, productionSpeed: 0.5, upgrade: Upgrade(maxAmount: 10, currentAmount: 0, oneCost: 420, tenCost: 100, fiftyCost: 500, hundredCost: 1000, maxCost: 99999), buyCost: 800, worker: Worker(cost: 100000))]
    
    
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
        guard let index = playerRocks.firstIndex(where: { $0.name == rock.name }),
              playerRocks[index].upgrade.currentAmount < playerRocks[index].upgrade.maxAmount,
              playerRocks[index].upgrade.oneCost <= currency.cash else { return }
        
        // Deduct cost, increase upgrade level, update cost & value
        currency.cash -= playerRocks[index].upgrade.oneCost
        playerRocks[index].upgrade.currentAmount += 1
        
        var shouldRestartTimer = false // Track if we need to restart the timer

        // Check if maxAmount is reached
        if playerRocks[index].upgrade.currentAmount >= playerRocks[index].upgrade.maxAmount {
            if playerRocks[index].upgrade.maxAmount < 25 {
                playerRocks[index].upgrade.maxAmount = 25
                playerRocks[index].productionSpeed *= 2
                print(playerRocks[index].productionSpeed)
                shouldRestartTimer = true
            } else if playerRocks[index].upgrade.maxAmount < 50 {
                playerRocks[index].upgrade.maxAmount = 50
                playerRocks[index].productionSpeed *= 2
                print(playerRocks[index].productionSpeed)
                shouldRestartTimer = true
            } else if playerRocks[index].upgrade.maxAmount < 100 {
                playerRocks[index].upgrade.maxAmount = 100
                playerRocks[index].productionSpeed *= 2
                print(playerRocks[index].productionSpeed)
                shouldRestartTimer = true
            } else if playerRocks[index].upgrade.maxAmount < 250 {
                playerRocks[index].upgrade.maxAmount = 250
                playerRocks[index].productionSpeed *= 2
                print(playerRocks[index].productionSpeed)
                shouldRestartTimer = true
            }
        }

        playerRocks[index].upgrade.oneCost = calculateNewCost(for: playerRocks[index])
        playerRocks[index].value = calculateUpdatedValue(for: playerRocks[index])

        // Restart the timer if production speed was changed
        if shouldRestartTimer {
            stopTimer(for: playerRocks[index]) // Stop the current timer
            startTimer(for: playerRocks[index]) // Start a new timer with the updated speed
        }
    }

    
    // Helper function to calculate new upgrade cost
    private func calculateNewCost(for rock: Rock) -> Float {
        let newCost = rock.upgrade.oneCost * (1.0 + Float(rock.upgrade.currentAmount) / 10.0)
        return (newCost * 1000).rounded() / 1000
    }
    
    // Helper function to calculate new rock value
    private func calculateUpdatedValue(for rock: Rock) -> Float {
        return ((rock.value * (1 + Float(rock.upgrade.currentAmount) / 15.0)) * 1000).rounded() / 1000
    }
    
    // Update all rock values efficiently
    func updateAllRockValues() {
        playerRocks.indices.forEach { playerRocks[$0].value = calculateUpdatedValue(for: playerRocks[$0]) }
    }
    
    
    
    func checkIfHasWorker(rock: Rock) -> Bool {
        if rock.worker.isBought {
            // If true return the boolean so the timer can start
            // then connect the timer to the percent of the progress bar
            return true
        } else {
            // If false return the boolean then check if you have enough money to buy the worker
            if currency.cash >= rock.worker.cost && rock.upgrade.currentAmount > 0 {
                currency.cash -= rock.worker.cost
                return true
            } else {
                return false
            }
        }
    }
    
    
    func startTimer(for rock: Rock) {
        let rockName = rock.name
        
        // Stop existing timer for this rock if it exists
        timers[rockName]?.invalidate()
        
        // Ensure counter exists for this rock
        counterDict[rockName] = counterDict[rockName] ?? 0.0
        
        // Find the index of the rock in playerRocks
        guard let index = playerRocks.firstIndex(where: { $0.name == rockName }) else { return }
        
        // 🔥 Fix: Use inverse of productionSpeed to speed up production
        let newInterval = max(0.001, 0.01 / Double(playerRocks[index].productionSpeed)) // Prevent division by zero
        
        print("Restarting timer for \(rockName) with interval: \(newInterval) (Speed: \(playerRocks[index].productionSpeed))")
        
        // Create a new timer for this rock
        timers[rockName] = Timer.scheduledTimer(withTimeInterval: newInterval, repeats: true) { [weak self] _ in
            guard let self = self else { return }

            if let currentCounter = self.counterDict[rockName] {
                let increment = 0.01 * Double(playerRocks[index].productionSpeed) // Scale progress with speed
                if currentCounter < 3.0 {
                    self.counterDict[rockName] = min(3.0, currentCounter + increment) // Prevent overshooting
                } else {
                    self.counterDict[rockName] = 0.0 // Reset
                    self.currency.cash += self.playerRocks[index].value
                }
            }
        }
    }

    
    
    func stopTimer(for rock: Rock) {
        let rockName = rock.name
        timers[rockName]?.invalidate()
        timers.removeValue(forKey: rockName)
        counterDict[rockName] = 0.0
    }
    
    //    deinit {
    //        stopTimer()
    //    }
    
}
