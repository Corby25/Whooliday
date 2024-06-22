//
//  DestinationSearchView.swift
//  Whooliday
//
//  Created by Fabio Tagliani on 20/06/24.
//

import SwiftUI
import CoreHaptics
import Combine

enum DestinationSearchOption{
    case location
    case dates
    case guests
}



struct DestinationSearchView: View {
    
   
    @State private var cancellable: AnyCancellable?
    

    @Binding var searchParameters: SearchParameters
    
    //haptic
    
    let generator = UIImpactFeedbackGenerator(style: .soft)
    
    // link between the two views, bind two state properties
    @Binding var show: Bool
    
    @State private var destination = ""
    @State private var selectedOption: DestinationSearchOption = .location
    
    // for date
    @State private var startDate = Date()
    @State private var endDate = Date()
    
    // for number of guests
    @State private var numGuests = 2
    
    // for location
    @State private var placeID = ""
    @State private var predictionsDictionary: [String: String] = [:]
    @State private var destinationSuggestions: [String] = []
    
    var body: some View {
        VStack{
            
            HStack {
                Button(){
                    // change Bool state
                    withAnimation(.snappy){
                        show.toggle()
                    }
                    
                }label:{
                    Image(systemName: "xmark.circle")
                        .imageScale(.large)
                        .foregroundColor(.black)
                }
                Spacer()
                
                if !destination.isEmpty {
                    Button("Clear"){
                        destination = ""
                        destinationSuggestions = []
                    }
                    .foregroundStyle(.black)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                }
            }
            .padding()
            
            /*
            VStack(alignment: .leading){
                if selectedOption == .location {
                    Text("Dove?")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    HStack{
                        Image(systemName: "magnifyingglass")
                            .imageScale(.small)
                        
                        TextField("Cerca Destinazione", text: $destination)
                            .font(.subheadline)
                    }
                    .frame(height: 44)
                    .padding(.horizontal)
                    .overlay{
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(lineWidth: /*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/)
                            .foregroundStyle(Color(.systemGray4))
                    }
                    
                }else{
                    CollapsedPickerView(title: "Dove", description: "Destinatione")
                }
                
            }
             
             */
            
            VStack(alignment: .leading) {
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
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(lineWidth: 1.0)
                                        .foregroundStyle(Color(.systemGray4))
                                }
                                
                                // Lista dei suggerimenti
                                List(destinationSuggestions, id: \.self) { suggestion in
                                    Text(suggestion)
                                        .onTapGesture {
                                            destination = suggestion
                                            placeID = predictionsDictionary[suggestion] ?? ""
                                            destinationSuggestions = []
                                        }
                                }
                                .frame(height: min(CGFloat(destinationSuggestions.count) * 44, 200))
                            } else {
                                CollapsedPickerView(title: "Dove", description: "Destinazione")
                            }
                        }
            .modifier(CollapsibleDestinationViewModifier())
            .frame(height: selectedOption == .location ? 120 : 64)
            
            .onTapGesture {
                withAnimation(.snappy){
                    selectedOption = .location
                }
               
            }
            
            // when
            VStack(alignment: .leading){
                if selectedOption == .dates {
                   Text("Quando vuoi partire?")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    VStack{
                        DatePicker("Da", selection: $startDate, displayedComponents: .date)
                            .onTapGesture {
                                generator.impactOccurred()
                            }
                           
                        
                        Divider()
                        
                        DatePicker("A", selection: $endDate, displayedComponents: .date)
                            .onTapGesture {
                                generator.impactOccurred()
                            }
                         
                    }
                    .foregroundStyle(.gray)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                }else {
                    CollapsedPickerView(title: "Quando", description: "Aggiungi date")
                }
            }
                .modifier(CollapsibleDestinationViewModifier())
                .frame(height: selectedOption == .dates ? 180 : 64)
                
                .onTapGesture{
                    withAnimation(.snappy){
                        selectedOption = .dates
                        generator.impactOccurred()
                    }
                }
            
            
            // who
            
            VStack(alignment: .leading){
                if selectedOption == .guests {
                   Text("Quanti")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .fontWeight(.semibold)
                    
                    Stepper{
                        Text("\(numGuests) Adulti")
                    } onIncrement: {
                        numGuests += 1
                    } onDecrement: {
                        guard numGuests > 1 else {return}
                        numGuests -= 1
                    }
                    .onChange(of: numGuests){
                        generator.impactOccurred()
                    }
                    
                
                        
                }else {
                    CollapsedPickerView(title: "Chi", description: "Aggiungi ospiti")
                }
            }
                .modifier(CollapsibleDestinationViewModifier())
                .frame(height: selectedOption == .guests ? 120 : 64)
                .onTapGesture{
                    withAnimation(.snappy){
                        selectedOption = .guests
                        generator.impactOccurred()
                    }
                }
            
            Spacer()
            VStack(alignment: .center) {
                            Button(action: {
                                searchParameters = SearchParameters(
                                                        destination: destination,
                                                        placeID: placeID,
                                                        startDate: startDate,
                                                        endDate: endDate,
                                                        guests: numGuests
                                                    )
                                                    show = false
                            }) {
                                Text("Cerca")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white) // Text color
                                    .frame(maxWidth: .infinity, maxHeight: .infinity) // Make the text take the full space
                                    .background(Color.pink) // Background color
                                    .cornerRadius(10) // Rounded corners
                            }
                            .frame(width: 150, height: 50) // Frame of the button
                //.modifier(CollapsibleDestinationViewModifier())
                        }
                        .padding() // Add padding around the VStack
           
            // other ...
            
        }
        Spacer()
        
        
        
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
    
    
  
}

#Preview {
    DestinationSearchView(
       
        searchParameters: .constant(SearchParameters(destination: "", placeID: "", startDate: Date(), endDate: Date(), guests: 2)),  show: .constant(false)
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
            .clipShape(RoundedRectangle(cornerRadius: 12))
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
    var startDate: Date
    var endDate: Date
    var guests: Int
}

