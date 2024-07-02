//
//  FilterModel.swift
//  Whooliday
//
//  Created by Fabio Tagliani on 02/07/24.
//

import Foundation

enum FilterCategory: String, CaseIterable {
    case general = "General"
    case amenities = "Amenities"
    case food = "Food & Drink"
    case activities = "Activities & Entertainment"
    case accessibility = "Accessibility"
    case transportation = "Transportation"
    case business = "Business Facilities"
    case family = "Family Services"
    case wellness = "Wellness"
    case cleaning = "Cleaning & Safety"
}

enum FilterOption: String, CaseIterable, Identifiable {
    // General
    case parking = "Parking"
    case freeParking = "Free parking"
    case freeWiFi = "Free WiFi"
    case petsAllowed = "Pets allowed"
    case nonSmokingRooms = "Non-smoking rooms"
    case airConditioning = "Air conditioning"
    case familyRooms = "Family rooms"
    case adultOnly = "Adult only"
    
    // Amenities
    case restaurant = "Restaurant"
    case bar = "Bar"
    case roomService = "Room service"
    case twentyFourHourFrontDesk = "24-hour front desk"
    case sauna = "Sauna"
    case fitnessCenter = "Fitness centre"
    case garden = "Garden"
    case terrace = "Terrace"
    case nonSmokingThroughout = "Non-smoking throughout"
    case bbqFacilities = "BBQ facilities"
    case heating = "Heating"
    case luggageStorage = "Luggage storage"
    
    // Food & Drink
    case breakfastAvailable = "Breakfast available"
    case restaurant_a_la_carte = "Restaurant (à la carte)"
    case restaurant_buffet = "Restaurant (buffet)"
    case snackBar = "Snack bar"
    case specialDietMenus = "Special diet menus (on request)"
    case kidsMenu = "Kid meals"
    
    // Activities & Entertainment
    case golf = "Golf course (within 3 km)"
    case tennis = "Tennis court"
    case fishing = "Fishing"
    case skiing = "Skiing"
    case gameRoom = "Games room"
    case casino = "Casino"
    case spa = "Spa and wellness centre"
    case massage = "Massage"
    case cyclingFacilities = "Cycling"
    case hikingFacilities = "Hiking"
    case nightclub = "Nightclub/DJ"
    case waterPark = "Water park"
    case eveningEntertainment = "Evening entertainment"
    
    // Accessibility
    case facilitiesForDisabled = "Facilities for disabled guests"
    case wheelchairAccessible = "Wheelchair accessible"
    case toiletWithGrabRails = "Toilet with grab rails"
    case higherLevelToilet = "Higher level toilet"
    case lowerBathroomSink = "Lower bathroom sink"
    case emergencyCordInBathroom = "Emergency cord in bathroom"
    case visualAidsBraille = "Visual aids: Braille"
    case visualAidsTactileSigns = "Visual aids: Tactile signs"
    case auditoryGuidance = "Auditory guidance"
    
    // Transportation
    case airportShuttle = "Airport shuttle"
    case carHire = "Car hire"
    case bikeHire = "Bicycle rental"
    case publicTransportTickets = "Public transport tickets"
    
    // Business Facilities
    case businessCenter = "Business centre"
    case meetingBanquetFacilities = "Meeting/banquet facilities"
    case faxPhotocopying = "Fax/photocopying"
    
    // Family Services
    case babysitting = "Babysitting/child services"
    case kidsClub = "Kids' club"
    case childrenPlayground = "Children's playground"
    
    // Wellness
    case indoorPool = "Indoor pool"
    case outdoorPool = "Outdoor pool"
    case hotTubJacuzzi = "Hot tub/Jacuzzi"
    case hammam = "Hammam"
    case turkishBath = "Turkish bath"
    
    // Cleaning & Safety
    case dailyHousekeeping = "Daily housekeeping"
    case securityAlarm = "Security alarm"
    case smokeAlarms = "Smoke alarms"
    case cctvCommonAreas = "CCTV in common areas"
    case cctvOutsideProperty = "CCTV outside property"
    case fireExtinguishers = "Fire extinguishers"
    
    var id: Self { self }
    
    var category: FilterCategory {
        switch self {
        case .parking, .freeParking, .freeWiFi, .petsAllowed, .nonSmokingRooms, .airConditioning, .familyRooms, .adultOnly:
            return .general
        case .restaurant, .bar, .roomService, .twentyFourHourFrontDesk, .sauna, .fitnessCenter, .garden, .terrace, .nonSmokingThroughout, .bbqFacilities, .heating, .luggageStorage:
            return .amenities
        case .breakfastAvailable, .restaurant_a_la_carte, .restaurant_buffet, .snackBar, .specialDietMenus, .kidsMenu:
            return .food
        case .golf, .tennis, .fishing, .skiing, .gameRoom, .casino, .spa, .massage, .cyclingFacilities, .hikingFacilities, .nightclub, .waterPark, .eveningEntertainment:
            return .activities
        case .facilitiesForDisabled, .wheelchairAccessible, .toiletWithGrabRails, .higherLevelToilet, .lowerBathroomSink, .emergencyCordInBathroom, .visualAidsBraille, .visualAidsTactileSigns, .auditoryGuidance:
            return .accessibility
        case .airportShuttle, .carHire, .bikeHire, .publicTransportTickets:
            return .transportation
        case .businessCenter, .meetingBanquetFacilities, .faxPhotocopying:
            return .business
        case .babysitting, .kidsClub, .childrenPlayground:
            return .family
        case .indoorPool, .outdoorPool, .hotTubJacuzzi, .hammam, .turkishBath:
            return .wellness
        case .dailyHousekeeping, .securityAlarm, .smokeAlarms, .cctvCommonAreas, .cctvOutsideProperty, .fireExtinguishers:
            return .cleaning
        }
    }
}

struct JsonFilter {
    let id: String
    let name: String
}

struct JsonCategory {
    let id: String
    let filters: [JsonFilter]
}

let simplifiedJson: [JsonCategory] = [
    JsonCategory(id: "popular", filters: [
        JsonFilter(id: "free_cancellation::1", name: "Free cancellation"),
        JsonFilter(id: "facility::433", name: "Swimming Pool"),
        JsonFilter(id: "facility::2", name: "Parking"),
        JsonFilter(id: "facility::46", name: "Free parking"),
        JsonFilter(id: "facility::107", name: "Free WiFi"),
        JsonFilter(id: "facility::4", name: "Pets allowed"),
        JsonFilter(id: "facility::28", name: "Family rooms"),
        JsonFilter(id: "facility::16", name: "Non-smoking rooms"),
        JsonFilter(id: "facility::109", name: "Air conditioning"),
        JsonFilter(id: "facility::149", name: "Adult only")
    ]),
    JsonCategory(id: "facility", filters: [
        JsonFilter(id: "hotel_facility_type_id::433", name: "Swimming Pool"),
        JsonFilter(id: "hotel_facility_type_id::2", name: "Parking"),
        JsonFilter(id: "hotel_facility_type_id::46", name: "Free parking"),
        JsonFilter(id: "hotel_facility_type_id::4", name: "Pets allowed"),
        JsonFilter(id: "hotel_facility_type_id::107", name: "Free WiFi"),
        JsonFilter(id: "hotel_facility_type_id::28", name: "Family rooms"),
        JsonFilter(id: "hotel_facility_type_id::54", name: "Spa and wellness centre"),
        JsonFilter(id: "hotel_facility_type_id::16", name: "Non-smoking rooms"),
        JsonFilter(id: "hotel_facility_type_id::11", name: "Fitness centre"),
        JsonFilter(id: "hotel_facility_type_id::3", name: "Restaurant"),
        JsonFilter(id: "hotel_facility_type_id::7", name: "Bar"),
        JsonFilter(id: "hotel_facility_type_id::5", name: "Room service"),
        JsonFilter(id: "hotel_facility_type_id::8", name: "24-hour front desk"),
        JsonFilter(id: "hotel_facility_type_id::10", name: "Sauna"),
        JsonFilter(id: "hotel_facility_type_id::14", name: "Garden"),
        JsonFilter(id: "hotel_facility_type_id::15", name: "Terrace"),
        JsonFilter(id: "hotel_facility_type_id::108", name: "Non-smoking throughout"),
        JsonFilter(id: "hotel_facility_type_id::72", name: "BBQ facilities"),
        JsonFilter(id: "hotel_facility_type_id::80", name: "Heating"),
        JsonFilter(id: "hotel_facility_type_id::91", name: "Luggage storage"),
        JsonFilter(id: "hotel_facility_type_id::17", name: "Airport shuttle"),
        JsonFilter(id: "hotel_facility_type_id::182", name: "Electric vehicle charging station"),
        JsonFilter(id: "hotel_facility_type_id::185", name: "Wheelchair accessible"),
        JsonFilter(id: "hotel_facility_type_id::139", name: "Airport shuttle (free)")
    ]),
    JsonCategory(id: "mealplan", filters: [
        JsonFilter(id: "mealplan::breakfast_included", name: "Breakfast included"),
        JsonFilter(id: "mealplan::breakfast_and_dinner", name: "Breakfast & dinner included"),
        JsonFilter(id: "mealplan::999", name: "Self catering")
    ]),
    JsonCategory(id: "room_facility", filters: [
        JsonFilter(id: "room_facility::11", name: "Air conditioning"),
        JsonFilter(id: "room_facility::38", name: "Private bathroom"),
        JsonFilter(id: "room_facility::17", name: "Balcony"),
        JsonFilter(id: "room_facility::93", name: "Private pool"),
        JsonFilter(id: "room_facility::999", name: "Kitchen/kitchenette"),
        JsonFilter(id: "room_facility::34", name: "Washing machine"),
        JsonFilter(id: "room_facility::16", name: "Kitchenette"),
        JsonFilter(id: "room_facility::20", name: "Spa bath"),
        JsonFilter(id: "room_facility::123", name: "Terrace"),
        JsonFilter(id: "room_facility::5", name: "Bath"),
        JsonFilter(id: "room_facility::81", name: "View"),
        JsonFilter(id: "room_facility::75", name: "Flat-screen TV"),
        JsonFilter(id: "room_facility::86", name: "Electric kettle"),
        JsonFilter(id: "room_facility::998", name: "Coffee/tea maker"),
        JsonFilter(id: "room_facility::37", name: "Patio"),
        JsonFilter(id: "room_facility::79", name: "Soundproofing"),
        JsonFilter(id: "room_facility::120", name: "Coffee machine")
    ]),
    JsonCategory(id: "district", filters: [
        JsonFilter(id: "district::2309", name: "Prague City Centre"),
        JsonFilter(id: "district::270", name: "Old Town (Stare Mesto)"),
        JsonFilter(id: "district::255", name: "Prague 1"),
        JsonFilter(id: "district::10095", name: "Guests' favourite area"),
        JsonFilter(id: "district::3255", name: "Nove Mesto"),
        JsonFilter(id: "district::271", name: "Lesser Quarter (Mala Strana)"),
        JsonFilter(id: "district::9999997", name: "Best areas outside centre")
    ]),
    JsonCategory(id: "class", filters: [
        JsonFilter(id: "class::0", name: "Unrated"),
        JsonFilter(id: "class::1", name: "1 star"),
        JsonFilter(id: "class::2", name: "2 stars"),
        JsonFilter(id: "class::3", name: "3 stars"),
        JsonFilter(id: "class::4", name: "4 stars"),
        JsonFilter(id: "class::5", name: "5 stars")
    ]),
    JsonCategory(id: "reviewscorebuckets", filters: [
        JsonFilter(id: "reviewscorebuckets::50", name: "Passable: 5+"),
        JsonFilter(id: "reviewscorebuckets::60", name: "Pleasant: 6+"),
        JsonFilter(id: "reviewscorebuckets::70", name: "Good: 7+"),
        JsonFilter(id: "reviewscorebuckets::80", name: "Very good: 8+"),
        JsonFilter(id: "reviewscorebuckets::90", name: "Superb: 9+")
    ])
]

func findJsonCategory(for category: FilterCategory) -> JsonCategory? {
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
    
    guard let jsonCategoryId = categoryMapping[category] else {
        return nil
    }
    
    return simplifiedJson.first { $0.id == jsonCategoryId }
}

func findJsonFilter(in category: JsonCategory, for filter: FilterOption) -> JsonFilter? {
    let filterNameMapping: [FilterOption: String] = [
        // General
        .parking: "Parking",
        .freeParking: "Free parking",
        .freeWiFi: "Free WiFi",
        .petsAllowed: "Pets allowed",
        .nonSmokingRooms: "Non-smoking rooms",
        .airConditioning: "Air conditioning",
        .familyRooms: "Family rooms",
        .adultOnly: "Adult only",
        
        // Amenities
        .restaurant: "Restaurant",
        .bar: "Bar",
        .roomService: "Room service",
        .twentyFourHourFrontDesk: "24-hour front desk",
        .sauna: "Sauna",
        .fitnessCenter: "Fitness centre",
        .garden: "Garden",
        .terrace: "Terrace",
        .nonSmokingThroughout: "Non-smoking throughout",
        .bbqFacilities: "BBQ facilities",
        .heating: "Heating",
        .luggageStorage: "Luggage storage",
        
        // Food & Drink
        .breakfastAvailable: "Breakfast available",
        .restaurant_a_la_carte: "Restaurant (à la carte)",
        .restaurant_buffet: "Restaurant (buffet)",
        .snackBar: "Snack bar",
        .specialDietMenus: "Special diet menus (on request)",
        .kidsMenu: "Kid meals",
        
        // Activities & Entertainment
        .golf: "Golf course (within 3 km)",
        .tennis: "Tennis court",
        .fishing: "Fishing",
        .skiing: "Skiing",
        .gameRoom: "Games room",
        .casino: "Casino",
        .spa: "Spa and wellness centre",
        .massage: "Massage",
        .cyclingFacilities: "Cycling",
        .hikingFacilities: "Hiking",
        .nightclub: "Nightclub/DJ",
        .waterPark: "Water park",
        .eveningEntertainment: "Evening entertainment",
        
        // Accessibility
        .facilitiesForDisabled: "Facilities for disabled guests",
        .wheelchairAccessible: "Wheelchair accessible",
        .toiletWithGrabRails: "Toilet with grab rails",
        .higherLevelToilet: "Higher level toilet",
        .lowerBathroomSink: "Lower bathroom sink",
        .emergencyCordInBathroom: "Emergency cord in bathroom",
        .visualAidsBraille: "Visual aids: Braille",
        .visualAidsTactileSigns: "Visual aids: Tactile signs",
        .auditoryGuidance: "Auditory guidance",
        
        // Transportation
        .airportShuttle: "Airport shuttle",
        .carHire: "Car hire",
        .bikeHire: "Bicycle rental",
        .publicTransportTickets: "Public transport tickets",
        
        // Business Facilities
        .businessCenter: "Business centre",
        .meetingBanquetFacilities: "Meeting/banquet facilities",
        .faxPhotocopying: "Fax/photocopying",
        
        // Family Services
        .babysitting: "Babysitting/child services",
        .kidsClub: "Kids' club",
        .childrenPlayground: "Children's playground",
        
        // Wellness
        .indoorPool: "Indoor pool",
        .outdoorPool: "Outdoor pool",
        .hotTubJacuzzi: "Hot tub/Jacuzzi",
        .hammam: "Hammam",
        .turkishBath: "Turkish bath",
        
        // Cleaning & Safety
        .dailyHousekeeping: "Daily housekeeping",
        .securityAlarm: "Security alarm",
        .smokeAlarms: "Smoke alarms",
        .cctvCommonAreas: "CCTV in common areas",
        .cctvOutsideProperty: "CCTV outside property",
        .fireExtinguishers: "Fire extinguishers"
    ]
    
    guard let jsonFilterName = filterNameMapping[filter] else {
        return nil
    }
    
    return category.filters.first { $0.name == jsonFilterName }
    }



struct PriceRange {
    var min: Double
    var max: Double
}


