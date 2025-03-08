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
            ForEach(gameplayVM.playerRocks) { rock in
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
    }
}

#Preview {
    Game_Screen()
}
