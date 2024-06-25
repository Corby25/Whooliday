//
//  ShimmeringViewDetail.swift
//  Whooliday
//
//  Created by Fabio Tagliani on 25/06/24.
//

import SwiftUI

struct ShimmeringViewDetail: View {
    @State private var isAnimating = false
    
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [.gray.opacity(0.3), .gray.opacity(0.5), .gray.opacity(0.3)]),
                       startPoint: .leading,
                       endPoint: .trailing)
            .frame(height: 20)
            .cornerRadius(4)
            .mask(Rectangle().fill(
                LinearGradient(gradient: Gradient(colors: [.clear, .white, .clear]),
                               startPoint: .leading,
                               endPoint: .trailing)
            ))
            .offset(x: isAnimating ? 200 : -200)
            .animation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false), value: isAnimating)
            .onAppear {
                isAnimating = true
            }
    }
}

#Preview {
    ShimmeringViewDetail()
}
