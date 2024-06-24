//
//  Listing.swift
//  Whooliday
//
//  Created by Fabio Tagliani on 21/06/24.
//

import Foundation

// list of listing
// each item has a unique identifier
struct Listing: Identifiable, Decodable, Hashable {
    let id: Int
    let latitude: Double
    let longitude: Double
    let name: String
    let strikethrough_price: Double?
    let review_count: Int
    let review_score: Double
    let images: [String]
    
    var price: Double {
        strikethrough_price ?? 0
    }
}



