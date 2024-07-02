//
//  Listing.swift
//  Whooliday
//
//  Created by Fabio Tagliani on 21/06/24.
//

import Foundation

// list of listing
// each item has a unique identifier
import Foundation

struct Listing: Identifiable, Decodable, Hashable {

    let id: Int
    let latitude: Double
    let longitude: Double
    let city: String
    let state: String
    let name: String
    var strikethrough_price: Double
    let review_count: Int
    let review_score: Double
    let checkin: String
    let checkout: String
    let nAdults: Int
    let nChildren: Int?
    let childrenAge: String?
    let currency: String
    let images: [String]
    
    var price: String {
          if strikethrough_price == -1 {
              return "Sold out"
          } else {
              return String(format: "%.2f", strikethrough_price)
          }
      }
}


