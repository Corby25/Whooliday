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
        ("logosmall", NSLocalizedString("All", comment: "Filter button for all types"), true, 0),
        ("bed.double", NSLocalizedString("Hotel", comment: "Filter button for hotels"), false, 204),
        ("house", NSLocalizedString("House", comment: "Filter button for houses"), false, 201),
        ("building", NSLocalizedString("Hostel", comment: "Filter button for hostels"), false, 203),
        ("sun.horizon", NSLocalizedString("Resort", comment: "Filter button for resorts"), false, 206),
        ("capsule", NSLocalizedString("Capsule", comment: "Filter button for capsule hotels"), false, 225),
        ("cup.and.saucer", NSLocalizedString("B&B", comment: "Filter button for bed and breakfasts"), false, 208),
        ("leaf", NSLocalizedString("Farm", comment: "Filter button for farms"), false, 210),
        ("tree", NSLocalizedString("Chalet", comment: "Filter button for chalets"), false, 228),
        ("sailboat", NSLocalizedString("Boat", comment: "Filter button for boats"), false, 234),
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
                        ? .orange
                        : (colorScheme == .dark ? .white : .black)
                    )
            }
            
            .frame(width: 78, height: 50)
            .foregroundColor(
                isSelected
                ? .orange
                    : (colorScheme == .dark ? .white : .black)
            )
        }
    }
}

#Preview {
    FilterView(selectedPropertyType: .constant(String("Hotel")), selectedTypeID: .constant(0))
}
