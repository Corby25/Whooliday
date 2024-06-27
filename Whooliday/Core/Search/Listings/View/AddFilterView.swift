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
        case wiFi = "WiFi"
        case freeWiFi = "Free WiFi"
        case petsAllowed = "Pets allowed"
        case nonSmokingRooms = "Non-smoking rooms"
        case airConditioning = "Air conditioning"
        case familyRooms = "Family rooms"
        case privateBeach = "Private beach area"
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
            case .parking, .freeParking, .wiFi, .freeWiFi, .petsAllowed, .nonSmokingRooms, .airConditioning, .familyRooms, .privateBeach, .adultOnly:
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
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 30) {
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
                        }
                        .foregroundStyle(.black)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
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
            
            VStack {
                Spacer()
                Button(action: {
                    // Apply filters and close view
                    show = false
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
}

struct FilterButton2: View {
    let filter: AddFilterView.FilterOption
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
        AddFilterView(show: .constant(true))
    }
}

enum FilterOption: String, CaseIterable {
    case freeBreakfast = "Free Breakfast"
    case freeWifi = "Free WiFi"
    case pool = "Pool"
    case parking = "Parking"
    case petFriendly = "Pet Friendly"
    case airConditioning = "Air Conditioning"
    case spa = "Spa"
    case gym = "Gym"
    case familyRooms = "Family Rooms"
    case nonsmoking = "Non-smoking Rooms"
}

extension FilterOption: Identifiable {
    var id: Self { self }
}
