//
//  FilterCategories.swift
//  Whooliday
//
//  Created by Fabio Tagliani on 02/07/24.
//

import Foundation

private func findJsonCategory(for category: FilterCategory) -> [String: Any]? {
    guard let jsonData = // Carica qui il tuo JSON come Data
          let json = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
          let filters = json["filters"] as? [[String: Any]] else {
        return nil
    }
    
    let categoryMapping: [FilterCategory: String] = [
        .general: "popular",
        .amenities: "facility",
        .food: "mealplan",
        .activities: "facility",
        .accessibility: "facility",
        .transportation: "facility",
        .business: "facility",
        .family: "facility",
        .wellness: "facility",
        .cleaning: "facility"
    ]
    
    guard let jsonCategoryName = categoryMapping[category] else {
        return nil
    }
    
    return filters.first { ($0["id"] as? String) == jsonCategoryName }
}

private func findJsonFilter(in category: [String: Any], for filter: FilterOption) -> (id: String, name: String)? {
    guard let categories = category["categories"] as? [[String: Any]] else {
        return nil
    }
    
    let filterNameMapping: [FilterOption: String] = [
        .parking: "Parking",
        .freeParking: "Free parking",
        .wiFi: "WiFi",
        .freeWiFi: "Free WiFi",
        .petsAllowed: "Pets allowed",
        .nonSmokingRooms: "Non-smoking rooms",
        .airConditioning: "Air conditioning",
        .familyRooms: "Family rooms",
        .privateBeach: "Private beach area",
        .adultOnly: "Adult only",
        // Aggiungi qui altri mapping necessari
    ]
    
    guard let jsonFilterName = filterNameMapping[filter] else {
        return nil
    }
    
    if let jsonFilter = categories.first(where: { ($0["name"] as? String) == jsonFilterName }) {
        if let id = jsonFilter["id"] as? String,
           let name = jsonFilter["name"] as? String {
            return (id: id, name: name)
        }
    }
    
    return nil
}
