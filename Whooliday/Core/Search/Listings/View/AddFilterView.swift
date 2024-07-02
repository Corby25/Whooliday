//
//  AddFilterView.swift
//  Whooliday
//
//  Created by Fabio Tagliani on 27/06/24.
//

import SwiftUI



struct AddFilterView: View {
    @Binding var show: Bool
    @State private var selectedFilters: Set<FilterOption> = []
    @State private var expandedCategories: Set<FilterCategory> = []
    @State private var filterString: String = ""
    @State private var priceRange: PriceRange = PriceRange(min: 0, max: 1000)
    @Binding var appliedFilters: String
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 30) {
                    // Header
                    HStack {
                        Button {
                            withAnimation(.snappy) {
                                show.toggle()
                            }
                        } label: {
                            Image(systemName: "xmark.circle")
                                .imageScale(.large)
                                .foregroundColor(.black)
                                .fontWeight(.semibold)
                        }
                        
                        Spacer()
                        
                        Text("Filters")
                            .font(.title2)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                        
                        Spacer()
                        
                        Button("Clear") {
                            selectedFilters.removeAll()
                            priceRange = PriceRange(min: 0, max: 1000)
                        }
                        .foregroundStyle(.black)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    // Filter Categories
                    ForEach(FilterCategory.allCases, id: \.self) { category in
                        VStack(alignment: .leading) {
                            Button(action: {
                                toggleCategory(category)
                            }) {
                                HStack {
                                    Text(category.rawValue)
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.black)
                                    Spacer()
                                    Image(systemName: expandedCategories.contains(category) ? "chevron.up" : "chevron.down")
                                }
                            }
                            .padding(.horizontal)
                            
                            if expandedCategories.contains(category) {
                                if category == .general {
                                    PriceRangeView(priceRange: $priceRange)
                                        .padding(.horizontal)
                                }
                                
                                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                                    ForEach(FilterOption.allCases.filter { $0.category == category }) { filter in
                                        FilterButton2(filter: filter, isSelected: selectedFilters.contains(filter)) {
                                            toggleFilter(filter)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    
                    Spacer(minLength: 80)
                }
            }
            
            // Apply Filters Button
            VStack {
                Spacer()
                Button(action: {
                    applyFilters()
                }) {
                    Text("Apply Filters")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(width: 200, height: 50)
                        .background(Color.orange)
                        .cornerRadius(15)
                }
                .padding(.bottom)
            }
        }
        .cornerRadius(15)
        .padding()
    }
    
    private func toggleFilter(_ filter: FilterOption) {
        if selectedFilters.contains(filter) {
            selectedFilters.remove(filter)
        } else {
            selectedFilters.insert(filter)
        }
    }
      
    private func toggleCategory(_ category: FilterCategory) {
        if expandedCategories.contains(category) {
            expandedCategories.remove(category)
        } else {
            expandedCategories.insert(category)
        }
    }
    
    private func applyFilters() {
           filterString = generateFilterString()
           appliedFilters = filterString
           print("Applied filters: \(filterString)")
           show = false
       }
    
    private func generateFilterString() -> String {
        var filterStrings: [String] = []
        
        // Aggiungi il range di prezzo
        filterStrings.append("price::EUR-\(Int(priceRange.min))-\(Int(priceRange.max))")
        
        // Aggiungi gli altri filtri
        for filter in selectedFilters {
            if let category = FilterCategory.allCases.first(where: { $0.rawValue == filter.category.rawValue }),
               let jsonCategory = findJsonCategory(for: category),
               let jsonFilter = findJsonFilter(in: jsonCategory, for: filter) {
                filterStrings.append(jsonFilter.id)
            } else {
                filterStrings.append("custom_filter:\(filter.rawValue)")
            }
        }
        
        return filterStrings.joined(separator: ",")
    }
}

struct PriceRangeView: View {
    @Binding var priceRange: PriceRange
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Price Range")
                .font(.subheadline)
                .fontWeight(.semibold)
            
            HStack {
                TextField("Min", value: $priceRange.min, formatter: NumberFormatter())
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Text("-")
                
                TextField("Max", value: $priceRange.max, formatter: NumberFormatter())
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}

struct FilterButton2: View {
    let filter: FilterOption
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(filter.rawValue)
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
            .foregroundColor(isSelected ? .white : .black)
            .padding()
            .frame(maxWidth: .infinity)
            .background(isSelected ? Color.orange : Color.gray.opacity(0.1))
            .cornerRadius(10)
        }
    }
}

struct AddFilterView_Previews: PreviewProvider {
    static var previews: some View {
        AddFilterView(show: .constant(true), appliedFilters: .constant(""))
    }
}
