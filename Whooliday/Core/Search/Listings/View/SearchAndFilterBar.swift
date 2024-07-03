//
//  SearchAndFilterBar.swift
//  Whooliday
//
//  Created by Fabio Tagliani on 20/06/24.
//

import SwiftUI


struct SearchAndFilterBar: View {
    @Binding var showFilterView: Bool
    @Binding var isFavorite: Bool
    var onFavoriteToggle: () -> Void
    var showFilterAndFavorite: Bool
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Dove?")
                    .font(.footnote)
                    .fontWeight(.semibold)
                Text("Ovunque - Sempre - Ospiti")
                    .font(.caption2)
                    .foregroundStyle(.gray)
            }
            
            Spacer()
            if(showFilterAndFavorite){
                           Button(action: onFavoriteToggle) {
                               Image(systemName: isFavorite ? "heart.fill" : "heart")
                                   .foregroundColor(isFavorite ? .red : .gray)
                                   .fontWeight(.bold)
                           }
            
            Button(action: {
                showFilterView.toggle()
            }, label: {
                Image(systemName: "line.3.horizontal.decrease")
                    .foregroundStyle(.black)
                    .fontWeight(.bold)
            })
            .frame(width: 50, height: 30)
        }
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .stroke(lineWidth: 0.5)
                .foregroundStyle(Color(.systemGray4))
                .shadow(color: .black.opacity(0.4), radius: 2)
        }
        .padding()
    }
    
 
}
struct SearchAndFilterBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchAndFilterBar(showFilterView: .constant(false), isFavorite: .constant(false), onFavoriteToggle: {}, showFilterAndFavorite: true)
    }
}
