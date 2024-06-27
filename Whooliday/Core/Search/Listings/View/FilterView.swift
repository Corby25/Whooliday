//
//  FilterView.swift
//  Whooliday
//
//  Created by Fabio Tagliani on 27/06/24.
//

import SwiftUI

struct FilterView: View {
    var body: some View {
        VStack(spacing: 0) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 0) {
                            ForEach(filterButtons, id: \.text) { button in
                                FilterButton(icon: button.icon, text: button.text, isCustomIcon: button.isCustomIcon)
                            }
                        }
                        .padding(.horizontal, 0)
                    }
                    .frame(height: 60)
            
            Rectangle()
                .fill(Color.clear)
                .frame(height: 1)
                .background(
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .shadow(color: Color.black.opacity(0.2), radius: 6, y: 2)
                )
        }
    }
    
    // Array di dati per i bottoni
    let filterButtons: [(icon: String, text: String, isCustomIcon: Bool)] = [
        ("logosmall", "Tutto", true),
        ("bed.double", "Hotel", false),
        ("house", "Casa", false),
        ("sun.horizon", "Resort", false),
        ("cup.and.saucer", "B&B", false),
        ("leaf", "Fattoria", false),
        ("sailboat", "Barca", false),
    ]
}

struct FilterButton: View {
    let icon: String
    let text: String
    let isCustomIcon: Bool
    
    var body: some View {
        VStack(spacing: 6) {
            if isCustomIcon {
                Image(icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 22, height: 22)
            } else {
                Image(systemName: icon)
                    .font(.system(size: 22))
                    .frame(height: 22)
            }
            
            
            Text(text)
                .font(.caption)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
        }
        .frame(width: 78, height: 50)  // Mantenuta la dimensione fissa per ogni bottone
    }
}

#Preview {
    FilterView()
}
