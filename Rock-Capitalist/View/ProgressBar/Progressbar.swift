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
    var percent: CGFloat = 50
    var color1 = Color.blue
    var color2 = Color.green
    
    var body: some View {
        let multiplier = width / 100
        
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: height, style: .continuous)
                .frame(width: width, height: height)
                .foregroundStyle(Color.black.opacity(0.1))
            
            RoundedRectangle(cornerRadius: height, style: .continuous)
                .frame(width: percent * multiplier, height: height)
                .background(LinearGradient(gradient: Gradient(colors: [color1, color2]), startPoint: .leading, endPoint: .trailing))
                .foregroundStyle(.clear)
                .clipShape(RoundedRectangle(cornerRadius: height, style: .continuous))
        }
    }
}

#Preview {
    Progressbar()
}
