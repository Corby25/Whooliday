//
//  FilterView.swift
//  Whooliday
//
//  Created by Fabio Tagliani on 27/06/24.
//

import SwiftUI
struct FilterView: View {
    @Binding var selectedPropertyType: String
        @Binding var selectedTypeID: Int
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 0) {
                    ForEach(filterButtons, id: \.text) { button in
                        FilterButton(icon: button.icon, text: button.text, isCustomIcon: button.isCustomIcon, isSelected: selectedPropertyType == button.text) {
                            selectedPropertyType = button.text
                            selectedTypeID = button.typeID
                        }
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
    
    let filterButtons: [(icon: String, text: String, isCustomIcon: Bool, typeID: Int)] = [
        ("logosmall", "Tutto", true, 0),
        ("bed.double", "Hotel", false, 204),
        ("house", "Casa", false, 201),
        ("building", "Hostel", false, 203),
        ("sun.horizon", "Resort", false, 206),
        ("capsule", "Capsule", false, 225),
        ("cup.and.saucer", "B&B", false, 208),
        ("leaf", "Fattoria", false, 210),
        ("tree", "Chalet", false, 228),
        ("sailboat", "Barca", false, 234),
    ]
}

struct FilterButton: View {
    let icon: String
    let text: String
    let isCustomIcon: Bool
    let isSelected: Bool
    let action: () -> Void
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        Button(action: action) {
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
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .foregroundColor(
                        isSelected
                            ? (colorScheme == .dark ? .orange : .white)
                            : .primary
                    )
            }
            
            .frame(width: 78, height: 50)
            .foregroundColor(
                isSelected
                    ? (colorScheme == .dark ? .orange : .white)
                    : .primary
            )
        }
    }
}

#Preview {
    FilterView(selectedPropertyType: .constant(String("Tutto")), selectedTypeID: .constant(0))
}
