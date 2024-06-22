//
//  DeveloperPreview.swift
//  Whooliday
//
//  Created by Fabio Tagliani on 21/06/24.
//

import Foundation



class DeveloperPreview{
    static let shared = DeveloperPreview()
    var listings: [Listing] = [
        .init(
            id: NSUUID().uuidString,
            hotelId: 344533,
            name: "Hotel Parigi",
            accomodationType: 255,
            numberReview: 43,
            rating: 3.4,
            latitude: 44.34453,
            longitude: 56.5599595,
            imageURLs: ["https://cf.bstatic.com/xdata/images/hotel/max1280x900/227062434.jpg?k=743cc9d60a64b496ddda3a686c92a99bb00daa5270f52677bb5d7ea7065e6013&o=", "https://cf.bstatic.com/xdata/images/hotel/max1280x900/227062446.jpg?k=1ad4bc9b2b897cb97fec53c7963c96346742ce23f818c50432a51fd2cbf4adba&o=",
                        "https://cf.bstatic.com/xdata/images/hotel/max1280x900/220281144.jpg?k=2244ca0f7b483a045193a981ebdbb6bef2504bdf784af774a0a4527e3590a846&o="],
            address: "Via Roma 12",
            city: "Parigi",
            state: "Francia",
            distanceFromCentre: 0.93,
            price: 123,
            amenities: [.wifi, .balcony],
            type: .hotel
        )
    ]
    
    
    
    
}
