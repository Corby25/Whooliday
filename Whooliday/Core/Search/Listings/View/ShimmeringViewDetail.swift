//
//  ShimmeringViewDetail.swift
//  Whooliday
//
//  Created by Fabio Tagliani on 25/06/24.
//

import SwiftUI

// shimmering used while loading additional information

struct ShimmeringViewDetail: View {
    @State private var isAnimating = false
    
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color.gray.opacity(0.3), Color.gray.opacity(0.5), Color.gray.opacity(0.3)]),
                       startPoint: .leading,
                       endPoint: .trailing)
        .frame(height: 20) // Altezza del placeholder
        .mask(Rectangle())
        .overlay(
            Rectangle()
                .fill(
                    LinearGradient(gradient: Gradient(colors: [.clear, .white.opacity(0.5), .clear]), startPoint: .leading, endPoint: .trailing)
                )
                .offset(x: isAnimating ? 200 : -200)
        )
        .onAppear {
            withAnimation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                isAnimating = true
            }
        }
    }
}
#Preview {
    ShimmeringViewDetail()
}
