//
//  ExploreViewModel.swift
//  Whooliday
//
//  Created by Fabio Tagliani on 21/06/24.
//

import Foundation

class ExploreViewModel: ObservableObject {
    @Published var listings = [Listing]()
    private let service: ExploreServiceProtocol
    @Published var isLoading = false
    
    init(service: ExploreServiceProtocol) {
        self.service = service
    }
    
    func fetchListings(with parameters: SearchParameters) {
        isLoading = true
        Task {
            do {
                try await service.getLatLong(with: String(parameters.placeID))
                
                let fetchedListings = try await service.fetchListings(with: parameters)
                DispatchQueue.main.async {
                    self.listings = fetchedListings
                    self.isLoading = false
                }
            } catch {
                print("Error fetching listings: \(error)")
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            }
        }
    }
    
    
}

protocol ExploreServiceProtocol {
    func getLatLong(with pid: String) async throws
       func fetchListings(with parameters: SearchParameters) async throws -> [Listing]
       func fetchListings() async throws -> [Listing]
}


