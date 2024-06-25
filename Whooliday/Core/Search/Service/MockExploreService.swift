//
//  MockExploreService.swift
//  Whooliday
//
//  Created by Fabio Tagliani on 25/06/24.
//

import Foundation

class MockExploreService: ExploreServiceProtocol {
    func getLatLong(with pid: String) async throws {
        // Simula il recupero delle coordinate
        // Non fa nulla in questo mock
    }
    
    func fetchListings(with parameters: SearchParameters) async throws -> [Listing] {
        // Restituisci dati di esempio
        return [
            Listing(id: 1, latitude: 41.9028, longitude: 12.4964, city: "Milano", state: "IT", name: "Luxury Hotel Roma", strikethrough_price: 250.0, review_count: 532, review_score: 4.7, checkin: "2024-07-01", checkout: "2024-07-05", nAdults: 2, nChildren: 0, childrenAge: "", currency: "EUR", images: ["https://cf.bstatic.com/xdata/images/hotel/max1280x900/513762841.jpg?k=4952a390602216d76f29b8d0171427cd5b7414e192c2d7d88572f2c1048cca3f&o=","https://cf.bstatic.com/xdata/images/hotel/max1280x900/513762841.jpg?k=4952a390602216d76f29b8d0171427cd5b7414e192c2d7d88572f2c1048cca3f&o="]),
            Listing(id: 2, latitude: 48.8566, longitude: 2.3522, city: "Milano", state: "IT", name: "Parisian Boutique Hotel", strikethrough_price: 180.0, review_count: 421, review_score: 4.5, checkin: "2024-07-01", checkout: "2024-07-05", nAdults: 2, nChildren: 1, childrenAge: "5", currency: "EUR", images: ["https://cf.bstatic.com/xdata/images/hotel/max1280x900/243157291.jpg?k=dcc41213d595d940967136ae9b4692ca4535bef4d4047497a253fadb9120315b&o=","https://cf.bstatic.com/xdata/images/hotel/max1280x900/513762841.jpg?k=4952a390602216d76f29b8d0171427cd5b7414e192c2d7d88572f2c1048cca3f&o="])
        ]
    }
}

class MockHotelDetailsService: HotelDetailsService {
    override func fetchHotelDetails(for listing: Listing) async throws -> HotelDetails {
        // Restituisci dati di esempio
        return HotelDetails(
            reviewScoreWord: "Eccellente",
            city: "Roma",
            state: "IT",
            accomodationType: "Hotel",
            numberOfBeds: "2",
            checkinFrom: "14:00",
            checkinTo: "23:00",
            checkoutFrom: "07:00",
            checkoutTo: "11:00",
            info: "Questo lussuoso hotel nel cuore di Roma offre una vista mozzafiato sulla città eterna.",
            accomodationID: 12345,
            facilities: "1, 2, 3, 4, 5"
        )
    }
}
