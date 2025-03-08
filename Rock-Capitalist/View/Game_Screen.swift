//
//  Game_Screen.swift
//  Rock-Capitalist
//
//  Created by Forrest Kalani Arnold on 3/7/25.
//

import SwiftUI

struct Game_Screen: View {
    
    @StateObject private var gameplayVM = Gameplay_VM()
    
    var body: some View {
        VStack {
            Text("$\(gameplayVM.currency.cash.description)")
            ScrollView {
                VStack {
                    ForEach(gameplayVM.playerRocks) { rock in
                        RockView(rock: rock, gameplayVM: gameplayVM)
                    }
                }
            }
        }
    }
}

// MARK: - RockView
struct RockView: View {
    let rock: Rock
    @ObservedObject var gameplayVM: Gameplay_VM
    
    var body: some View {
        HStack {
            RockIconView(rock: rock)
            RockDetailsView(rock: rock, gameplayVM: gameplayVM)
        }
    }
}

// MARK: - RockIconView
struct RockIconView: View {
    let rock: Rock
    
    var body: some View {
        ZStack {
            Image("IconBackground")
            Image(rock.name)
            HStack {
                Text("\(rock.upgrade.currentAmount.description)  /")
                Text(rock.upgrade.maxAmount.description)
            }
            .foregroundStyle(Color.white)
            .bold()
            .padding(.top, 63)
        }
    }
}

// MARK: - RockDetailsView
struct RockDetailsView: View {
    let rock: Rock
    @ObservedObject var gameplayVM: Gameplay_VM
    
    var body: some View {
        VStack {
            IncomeView(rock: rock, gameplayVM: gameplayVM)
            PurchaseOptionsView(rock: rock, gameplayVM: gameplayVM)
        }
    }
}

// MARK: - IncomeView
struct IncomeView: View {
    let rock: Rock
    @ObservedObject var gameplayVM: Gameplay_VM
    
    var body: some View {
        ZStack {
            if rock.upgrade.currentAmount != 0 {
                ProgressbarView(rock: rock, gameplayVM: gameplayVM)
                Text("\(rock.value.description)")
            } else {
                Image("IncomeBar")
            }
        }
        .onTapGesture {
            if rock.upgrade.currentAmount != 0 {
                gameplayVM.produceButtonPressed(rock: rock)
            }
        }
    }
}

// MARK: - PurchaseOptionsView
struct PurchaseOptionsView: View {
    let rock: Rock
    @ObservedObject var gameplayVM: Gameplay_VM
    
    var body: some View {
        HStack {
            ZStack {
                Image("PurchaseButton")
                if rock.upgrade.currentAmount != 0 {
                    UpgradeButton(rock: rock, gameplayVM: gameplayVM)
                } else {
                    BuyRockButton(rock: rock, gameplayVM: gameplayVM)
                }
            }
            .frame(width: 140, height: 20, alignment: .center)
            
            ZStack {
                Image("SpeedBar")
                TimerView(rock: rock, gameplayVM: gameplayVM)
            }
        }
    }
}

// MARK: - UpgradeButton
struct UpgradeButton: View {
    let rock: Rock
    @ObservedObject var gameplayVM: Gameplay_VM
    
    var body: some View {
        VStack {
            HStack {
                Text("Buy")
                Spacer()
                Text("$\(rock.upgrade.oneCost.description)")
            }
            HStack {
                Text("x1")
                Spacer()
                Text("Dollars")
            }
        }
        .frame(width: 130, height: 12, alignment: .center)
        .onTapGesture {
            gameplayVM.checkIfCanUpgrade(rock: rock)
        }
    }
}

// MARK: - BuyRockButton
struct BuyRockButton: View {
    let rock: Rock
    @ObservedObject var gameplayVM: Gameplay_VM
    
    var body: some View {
        Text("Buy \(rock.name): $\(rock.buyCost.description)")
            .onTapGesture {
                gameplayVM.checkIfCanBuyRock(rock: rock)
            }
    }
}

// MARK: - ProgressBarView
struct ProgressbarView: View {
    let rock: Rock
    @ObservedObject var gameplayVM: Gameplay_VM
    
    @State var percent: CGFloat = 0
    
    var body: some View {
        ZStack {
            Progressbar(width: 230, height: 30, percent: CGFloat(gameplayVM.counterDict[rock.name] ?? 0.0) / 3 * 100, color1: Color.blue, color2: Color.cyan)
        }
    }
}


// MARK: - TimerView
struct TimerView: View {
    let rock: Rock
    @ObservedObject var gameplayVM: Gameplay_VM
    
    @State var hasWorker = false

    var body: some View {
        VStack {
            if gameplayVM.counterDict[rock.name] != nil { // Check if rock has a worker (is in the counterDict)
                Text("\(String(format: "%.2f", gameplayVM.counterDict[rock.name] ?? 0.0))") // Display with 2 decimal places
            } else {
                Button("$\(Int(rock.worker.cost))") {
                    if gameplayVM.checkIfHasWorker(rock: rock) {
                        gameplayVM.startTimer(for: rock)
                    }
                }
                .foregroundStyle(.black)
            }
        }
        .onDisappear {
            gameplayVM.stopTimer(for: rock) // Stop timer when the view disappears
        }
    }
}


#Preview {
    Game_Screen()
}
