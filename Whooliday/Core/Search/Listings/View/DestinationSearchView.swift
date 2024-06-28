//
//  DestinationSearchView.swift
//  Whooliday
//
//  Created by Fabio Tagliani on 20/06/24.
//

import SwiftUI
import CoreHaptics
import Combine

enum DestinationSearchOption {
    case location
    case dates
    case guests
}

struct DestinationSearchView: View {
    @State private var cancellable: AnyCancellable?
    @Binding var searchParameters: SearchParameters
    @Binding var show: Bool
    @Binding var navigateToExplore: Bool
    @State private var numAdults = 2
    @State private var numChildren = 0
    @State private var childrenAges: [Int] = []
    
    let generator = UIImpactFeedbackGenerator(style: .soft)
    
    @State private var destination = ""
    @State private var selectedOption: DestinationSearchOption = .location
    @State private var startDate: Date? = nil
    @State private var endDate: Date? = nil
    @State private var placeID = ""
    @State private var predictionsDictionary: [String: String] = [:]
    @State private var destinationSuggestions: [String] = []
    

    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 8) {
                    HStack {
                        Button {
                            withAnimation(.snappy) {
                                show.toggle()
                            }
                        } label: {
                            Image(systemName: "xmark.circle")
                                .imageScale(.large)
                                .foregroundColor(.black)
                        }
                        Spacer()
                        
                        if !destination.isEmpty {
                            Button("Clear") {
                                destination = ""
                                destinationSuggestions = []
                            }
                            .foregroundStyle(.black)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    // Location Section
                    VStack(alignment: .leading, spacing: 8) {
                        if selectedOption == .location {
                            Text("Dove?")
                                .font(.title2)
                                .fontWeight(.semibold)
                            
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .imageScale(.small)
                                
                                TextField("Cerca Destinazione", text: $destination)
                                    .font(.subheadline)
                                    .onChange(of: destination) { oldValue, newValue in
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                            if newValue == destination {
                                                fetchDestinationSuggestions(for: newValue)
                                            }
                                        }
                                    }
                            }
                            .frame(height: 44)
                            .padding(.horizontal)
                            .overlay {
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(lineWidth: 1.0)
                                    .foregroundStyle(Color(.systemGray4))
                            }
                            
                            if !destinationSuggestions.isEmpty {
                                List(destinationSuggestions, id: \.self) { suggestion in
                                    Text(suggestion)
                                        .onTapGesture {
                                            destination = suggestion
                                            placeID = predictionsDictionary[suggestion] ?? ""
                                            destinationSuggestions = []
                                        }
                                }
                                .listStyle(PlainListStyle())
                                .frame(height: min(CGFloat(destinationSuggestions.count) * 44, 200))
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                            }
                        } else {
                            CollapsedPickerView(title: "Dove", description: destination.isEmpty ? "Destinazione" : destination)
                        }
                    }
                    .modifier(CollapsibleDestinationViewModifier())
                    .onTapGesture {
                        withAnimation(.snappy) {
                            selectedOption = .location
                        }
                    }
                    
                    // Date Section
                    VStack(alignment: .leading, spacing: 8) {
                        if selectedOption == .dates {
                            Text("Quando vuoi partire?")
                                .font(.title2)
                                .fontWeight(.semibold)
                            
                            CalendarView(startDate: $startDate, endDate: $endDate)
                                .frame(height: 300)
                        } else {
                            CollapsedPickerView(title: "Quando", description: getDateDescription())
                        }
                    }
                    .modifier(CollapsibleDestinationViewModifier())
                    .onTapGesture {
                        withAnimation(.snappy) {
                            selectedOption = .dates
                            generator.impactOccurred()
                        }
                    }
                    
                    // Guests Section
                    VStack(alignment: .leading, spacing: 8) {
                        if selectedOption == .guests {
                            Text("Quanti")
                                .font(.title2)
                                .fontWeight(.semibold)
                            
                            GuestCounterView(title: "Adulti", count: $numAdults, minimum: 1)
                            
                            GuestCounterView(title: "Bambini", count: $numChildren, minimum: 0)
                            
                            if numChildren > 0 {
                                Text("Età dei bambini")
                                    .font(.title3)
                                    .fontWeight(.medium)
                                    .padding(.top, 4)
                                
                                ForEach(0..<numChildren, id: \.self) { index in
                                    Picker("Età bambino \(index + 1)", selection: Binding(
                                        get: { self.childrenAges.count > index ? self.childrenAges[index] : 0 },
                                        set: {
                                            if self.childrenAges.count > index {
                                                self.childrenAges[index] = $0
                                            } else {
                                                self.childrenAges.append($0)
                                            }
                                        }
                                    )) {
                                        ForEach(0...17, id: \.self) { age in
                                            Text("\(age)")
                                        }
                                    }
                                    .pickerStyle(MenuPickerStyle())
                                }
                            }
                        } else {
                            CollapsedPickerView(title: "Chi", description: getGuestsDescription())
                        }
                    }
                    .modifier(CollapsibleDestinationViewModifier())
                    .onTapGesture {
                        withAnimation(.snappy) {
                            selectedOption = .guests
                            generator.impactOccurred()
                        }
                    }
                    
                    Spacer(minLength: 80)
                }
            }
            
            VStack {
                Spacer()
                Button(action: {
                    if let start = startDate, let end = endDate, start != end {
                        searchParameters = SearchParameters(
                            destination: destination,
                            placeID: placeID,
                            startDate: start,
                            endDate: end,
                            numAdults: numAdults,
                            numChildren: numChildren,
                            childrenAges: childrenAges
                        )
                        navigateToExplore = true
                        show = false
                    }
                }) {
                    Text("Cerca")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(width: 150, height: 50)
                        .background(startDate != nil && endDate != nil && startDate != endDate ? Color.orange : Color.gray)
                        .cornerRadius(15)
                }
                .disabled(startDate == nil || endDate == nil || startDate == endDate)
                .padding(.bottom)
            }
        }
        .background(Color.white)
        .cornerRadius(15)
        .padding()
    }

    private func getGuestsDescription() -> String {
        var description = "\(numAdults) adult\(numAdults > 1 ? "i" : "o")"
        if numChildren > 0 {
            description += ", \(numChildren) bambin\(numChildren > 1 ? "i" : "o")"
        }
        return description
    }
    
    func fetchDestinationSuggestions(for query: String) {
           guard !query.isEmpty else {
               destinationSuggestions = []
               return
           }

           // Annulla la richiesta precedente se esiste
           cancellable?.cancel()

           // Sostituisci "YOUR_API_KEY" con la tua chiave API di Google Places
           let apiKey = "AIzaSyBOiUNEOqhpqUt_dyQTmcCKnscHfJE1VQY"
           let baseURL = "https://maps.googleapis.com/maps/api/place/autocomplete/json"
           let urlString = "\(baseURL)?input=\(query)&types=(cities)&key=\(apiKey)"

           guard let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else { return }

        cancellable = URLSession.shared.dataTaskPublisher(for: url)
                .map { $0.data }
                .decode(type: GooglePlacesResponse.self, decoder: JSONDecoder())
                .map { $0.predictions }
                .replaceError(with: [])
                .receive(on: DispatchQueue.main)
                .sink { predictions in
                    self.destinationSuggestions = predictions.map { $0.description }
                    self.predictionsDictionary = Dictionary(uniqueKeysWithValues: predictions.map { ($0.description, $0.placeID) })
                }
       }
    
    private func getDateDescription() -> String {
        if let start = startDate, let end = endDate {
            return "\(formatDate(start)) - \(formatDate(end))"
        } else {
            return "Seleziona le date"
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM"
        return formatter.string(from: date)
    }
}

// Le altre strutture e definizioni rimangono invariate

#Preview {
    DestinationSearchView(
       
        searchParameters: .constant(SearchParameters(destination: "", placeID: "", startDate: Date(), endDate: Date(), numAdults: 2, numChildren: 0, childrenAges: [])),  show: .constant(false), navigateToExplore: .constant(false)
    )
}
struct GooglePlacesResponse: Codable {
    let predictions: [Prediction]
}

struct Prediction: Codable {
    let description: String
    let placeID: String
    
    enum CodingKeys: String, CodingKey {
            case description
            case placeID = "place_id"
        }
}



struct CollapsibleDestinationViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding()
            .shadow(radius: 10)
    }
}

struct CollapsedPickerView: View {
    let title: String
    let description: String
    var body: some View {
        VStack{
            HStack{
                Text(title)
                    .foregroundStyle(.gray)
                
                Spacer()
                
                Text(description)
            }
            .fontWeight(.semibold)
            .font(.subheadline)
        }
      
    }
}

struct SearchParameters {
    var destination: String
    var placeID: String
    var startDate: Date?
    var endDate: Date?
    var numAdults: Int
    var numChildren: Int
    var childrenAges: [Int]
}

struct GuestCounterView: View {
    let title: String
    @Binding var count: Int
    let minimum: Int
    let generator = UIImpactFeedbackGenerator(style: .soft)
    
    var body: some View {
        HStack {
            Text(title)
                .font(.title3)
                .fontWeight(.medium)
            
            Spacer()
            
            HStack(spacing: 20) {
                Button(action: {
                    if count > minimum {
                        count -= 1
                        generator.impactOccurred()
                    }
                }) {
                    Image(systemName: "minus.circle.fill")
                        .foregroundColor(count > minimum ? .orange : .gray)
                        .font(.title2)
                }
                
                Text("\(count)")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .frame(minWidth: 30)
                
                Button(action: {
                    count += 1
                    generator.impactOccurred()
                }) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.orange)
                        .font(.title2)
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}
