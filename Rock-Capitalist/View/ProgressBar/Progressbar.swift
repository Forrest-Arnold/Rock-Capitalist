//
//  Progressbar.swift
//  Rock-Capitalist
//
//  Created by Forrest Kalani Arnold on 3/7/25.
//

import SwiftUI

struct Progressbar: View {
    
    var width: CGFloat = 200
    var height: CGFloat = 26
    var percent: CGFloat
    var color1 = Color.blue
    var color2 = Color.green
    var maskImage = "IncomeBar"
    
    var body: some View {
        let multiplier = width / 100
        
        ZStack(alignment: .leading) {
            // Background shape
            Image(maskImage)
                .resizable()
                .frame(width: width, height: height)
                .opacity(0.2) // Faint background shape
            
            // Progress fill clipped to the image shape
            Image(maskImage)
                .resizable()
                .frame(width: width, height: height)
                .overlay(
                    GeometryReader { geometry in
                        LinearGradient(gradient: Gradient(colors: [color1, color2]), startPoint: .leading, endPoint: .trailing)
                            .frame(width: percent * multiplier, height: height)
                            .position(x: (percent * multiplier) / 2, y: height / 2) // Shift leftwards
                    }
                )
                .mask(Image(maskImage).resizable().frame(width: width, height: height)) // Apply mask
        }
        .frame(width: width, height: height, alignment: .leading) // Ensure leading alignment
    }
}
