//
//  FavoriteModelTest.swift
//  WhoolidayTests
//
//  Created by Fabio Tagliani on 10/07/24.
//

import XCTest
import Combine
@testable import Whooliday 
// MARK: - Protocols

protocol FavoritesModelProtocol: ObservableObject {
    var hotels: [Hotel] { get set }
    var filters: [Filter] { get set }
    var isLoadingHotels: Bool { get set }
    var isLoadingFilterHotels: Bool { get set }
    var userCurrency: String { get set }
    
    func fetchFavorites() async
    func fetchHotels() async
    func fetchFilters() async
    func fetchHotelsForFilter(_ filter: Filter) async
    func deleteHotel(_ hotel: Hotel)
    func makeHotelAsSeen(_ hotel: Hotel)
    func deleteFilter(withId id: String)
    func markFilterAsNotNew(withId id: String)
    func refreshHotels() async
    func refreshFilters() async
}

// MARK: - Mock

class MockFavoritesModel: FavoritesModelProtocol {
    @Published var hotels: [Hotel] = []
    @Published var filters: [Filter] = []
    @Published var isLoadingHotels = false
    @Published var isLoadingFilterHotels = false
    @Published var userCurrency: String = "USD"
    
    var fetchFavoritesCallCount = 0
    var fetchHotelsCallCount = 0
    var fetchFiltersCallCount = 0
    var fetchHotelsForFilterCallCount = 0
    var deleteHotelCallCount = 0
    var makeHotelAsSeenCallCount = 0
    var deleteFilterCallCount = 0
    var markFilterAsNotNewCallCount = 0
    var refreshHotelsCallCount = 0
    var refreshFiltersCallCount = 0
    
    func fetchFavorites() async {
        fetchFavoritesCallCount += 1
        await fetchHotels()
        await fetchFilters()
    }
    
    func fetchHotels() async {
        fetchHotelsCallCount += 1
        isLoadingHotels = true
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        hotels = [
            Hotel(hotelID: "1", isNew: true, adultsNumber: 2, childrenNumber: 0, childrenAge: nil, checkIn: "2023-07-01", checkOut: "2023-07-05", newPrice: 100.0, oldPrice: 120.0, isDeleted: false, name: "Test Hotel 1"),
            Hotel(hotelID: "2", isNew: false, adultsNumber: 2, childrenNumber: 1, childrenAge: "5", checkIn: "2023-07-01", checkOut: "2023-07-05", newPrice: 150.0, oldPrice: 180.0, isDeleted: false, name: "Test Hotel 2")
        ]
        isLoadingHotels = false
    }
    
    func fetchFilters() async {
        fetchFiltersCallCount += 1
        filters = [
            Filter(id: "1", maxPrice: 100, latitude: 0, longitude: 0, adultsNumber: 2, orderBy: "price", roomNumber: 1, units: "metric", checkIn: "2023-07-01", checkOut: "2023-07-05", childrenNumber: 0, childrenAge: "", filters: "", city: "Test City 1", isDeleted: false, isNew: true, hotels: []),
            Filter(id: "2", maxPrice: 200, latitude: 1, longitude: 1, adultsNumber: 3, orderBy: "rating", roomNumber: 2, units: "imperial", checkIn: "2023-08-01", checkOut: "2023-08-05", childrenNumber: 1, childrenAge: "5", filters: "", city: "Test City 2", isDeleted: false, isNew: false, hotels: [])
        ]
    }
    
    func fetchHotelsForFilter(_ filter: Filter) async {
        fetchHotelsForFilterCallCount += 1
        isLoadingFilterHotels = true
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        if let index = filters.firstIndex(where: { $0.id == filter.id }) {
            filters[index].hotels = [Hotel(hotelID: "3", isNew: true, adultsNumber: 2, childrenNumber: 0, childrenAge: nil, checkIn: "2023-07-01", checkOut: "2023-07-05", newPrice: 120.0, oldPrice: 150.0, isDeleted: false, name: "Filtered Hotel")]
        }
        isLoadingFilterHotels = false
    }
    
    func deleteHotel(_ hotel: Hotel) {
        deleteHotelCallCount += 1
        if let index = hotels.firstIndex(where: { $0.hotelID == hotel.hotelID }) {
            hotels[index].isDeleted = true
        }
    }
    
    func makeHotelAsSeen(_ hotel: Hotel) {
        makeHotelAsSeenCallCount += 1
        if let index = hotels.firstIndex(where: { $0.hotelID == hotel.hotelID }) {
            hotels[index].isNew = false
        }
    }
    
    func deleteFilter(withId id: String) {
        deleteFilterCallCount += 1
        if let index = filters.firstIndex(where: { $0.id == id }) {
            filters[index].isDeleted = true
        }
    }
    
    func markFilterAsNotNew(withId id: String) {
        markFilterAsNotNewCallCount += 1
        if let index = filters.firstIndex(where: { $0.id == id }) {
            filters[index].isNew = false
        }
    }
    
    func refreshHotels() async {
        refreshHotelsCallCount += 1
        hotels.removeAll()
        await fetchHotels()
    }
    
    func refreshFilters() async {
        refreshFiltersCallCount += 1
        filters.removeAll()
        await fetchFilters()
    }
}

// MARK: - Tests

class FavoritesModelTests: XCTestCase {
    var mockModel: MockFavoritesModel!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockModel = MockFavoritesModel()
        cancellables = []
    }
    
    override func tearDown() {
        mockModel = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testFetchFavorites() async {
        await mockModel.fetchFavorites()
        XCTAssertEqual(mockModel.fetchFavoritesCallCount, 1)
        XCTAssertEqual(mockModel.fetchHotelsCallCount, 1)
        XCTAssertEqual(mockModel.fetchFiltersCallCount, 1)
        XCTAssertFalse(mockModel.hotels.isEmpty)
        XCTAssertFalse(mockModel.filters.isEmpty)
    }
    
    func testFetchHotels() async {
        await mockModel.fetchHotels()
        XCTAssertEqual(mockModel.fetchHotelsCallCount, 1)
        XCTAssertEqual(mockModel.hotels.count, 2)
        XCTAssertEqual(mockModel.hotels[0].name, "Test Hotel 1")
        XCTAssertEqual(mockModel.hotels[1].name, "Test Hotel 2")
    }
    
    func testFetchFilters() async {
        await mockModel.fetchFilters()
        XCTAssertEqual(mockModel.fetchFiltersCallCount, 1)
        XCTAssertEqual(mockModel.filters.count, 2)
        XCTAssertEqual(mockModel.filters[0].city, "Test City 1")
        XCTAssertEqual(mockModel.filters[1].city, "Test City 2")
    }
    
    func testFetchHotelsForFilter() async {
        // Creiamo un filtro e lo aggiungiamo al mockModel
        let filter = Filter(id: "1", maxPrice: 100, latitude: 0, longitude: 0, adultsNumber: 2, orderBy: "price", roomNumber: 1, units: "metric", checkIn: "2023-07-01", checkOut: "2023-07-05", childrenNumber: 0, childrenAge: "", filters: "", city: "Test City", isDeleted: false, isNew: true, hotels: [])
        mockModel.filters = [filter]

        // Eseguiamo fetchHotelsForFilter
        await mockModel.fetchHotelsForFilter(filter)

        // Verifichiamo i risultati
        XCTAssertEqual(mockModel.fetchHotelsForFilterCallCount, 1)
        XCTAssertFalse(mockModel.filters.isEmpty, "Filters array should not be empty")
        
        if let updatedFilter = mockModel.filters.first(where: { $0.id == "1" }) {
            XCTAssertEqual(updatedFilter.hotels.count, 1, "There should be one hotel in the filter")
            XCTAssertEqual(updatedFilter.hotels.first?.name, "Filtered Hotel", "The hotel name should be 'Filtered Hotel'")
        } else {
            XCTFail("Could not find the filter with id '1'")
        }
    }
    
    func testDeleteHotel() {
        let hotel = Hotel(hotelID: "1", isNew: true, adultsNumber: 2, childrenNumber: 0, childrenAge: nil, checkIn: "2023-07-01", checkOut: "2023-07-05", newPrice: 100.0, oldPrice: 120.0, isDeleted: false, name: "Test Hotel 1")
        mockModel.hotels = [hotel]
        
        mockModel.deleteHotel(hotel)
        
        XCTAssertEqual(mockModel.deleteHotelCallCount, 1)
        XCTAssertTrue(mockModel.hotels[0].isDeleted)
    }
    
    func testMakeHotelAsSeen() {
        let hotel = Hotel(hotelID: "1", isNew: true, adultsNumber: 2, childrenNumber: 0, childrenAge: nil, checkIn: "2023-07-01", checkOut: "2023-07-05", newPrice: 100.0, oldPrice: 120.0, isDeleted: false, name: "Test Hotel 1")
        mockModel.hotels = [hotel]
        
        mockModel.makeHotelAsSeen(hotel)
        
        XCTAssertEqual(mockModel.makeHotelAsSeenCallCount, 1)
        XCTAssertFalse(mockModel.hotels[0].isNew)
    }
    
    func testDeleteFilter() {
        let filter = Filter(id: "1", maxPrice: 100, latitude: 0, longitude: 0, adultsNumber: 2, orderBy: "price", roomNumber: 1, units: "metric", checkIn: "2023-07-01", checkOut: "2023-07-05", childrenNumber: 0, childrenAge: "", filters: "", city: "Test City", isDeleted: false, isNew: true, hotels: [])
        mockModel.filters = [filter]
        
        mockModel.deleteFilter(withId: "1")
        
        XCTAssertEqual(mockModel.deleteFilterCallCount, 1)
        XCTAssertTrue(mockModel.filters[0].isDeleted)
    }
    
    func testMarkFilterAsNotNew() {
        let filter = Filter(id: "1", maxPrice: 100, latitude: 0, longitude: 0, adultsNumber: 2, orderBy: "price", roomNumber: 1, units: "metric", checkIn: "2023-07-01", checkOut: "2023-07-05", childrenNumber: 0, childrenAge: "", filters: "", city: "Test City", isDeleted: false, isNew: true, hotels: [])
        mockModel.filters = [filter]
        
        mockModel.markFilterAsNotNew(withId: "1")
        
        XCTAssertEqual(mockModel.markFilterAsNotNewCallCount, 1)
        XCTAssertFalse(mockModel.filters[0].isNew)
    }
    
    func testRefreshHotels() async {
        await mockModel.refreshHotels()
        XCTAssertEqual(mockModel.refreshHotelsCallCount, 1)
        XCTAssertEqual(mockModel.fetchHotelsCallCount, 1)
        XCTAssertEqual(mockModel.hotels.count, 2)
    }
    
    func testRefreshFilters() async {
        await mockModel.refreshFilters()
        XCTAssertEqual(mockModel.refreshFiltersCallCount, 1)
        XCTAssertEqual(mockModel.fetchFiltersCallCount, 1)
        XCTAssertEqual(mockModel.filters.count, 2)
    }
    
    func testIsLoadingHotels() {
        let expectation = XCTestExpectation(description: "isLoadingHotels changes")
        var values: [Bool] = []
        
        mockModel.$isLoadingHotels
            .sink { value in
                values.append(value)
                if values.count == 3 {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        Task {
            await mockModel.fetchHotels()
        }
        
        wait(for: [expectation], timeout: 5.0)
        XCTAssertEqual(values, [false, true, false])
    }
    
    func testIsLoadingFilterHotels() {
        let expectation = XCTestExpectation(description: "isLoadingFilterHotels changes")
        var values: [Bool] = []
        
        mockModel.$isLoadingFilterHotels
            .sink { value in
                values.append(value)
                if values.count == 3 {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        let filter = Filter(id: "1", maxPrice: 100, latitude: 0, longitude: 0, adultsNumber: 2, orderBy: "price", roomNumber: 1, units: "metric", checkIn: "2023-07-01", checkOut: "2023-07-05", childrenNumber: 0, childrenAge: "", filters: "", city: "Test City", isDeleted: false, isNew: true, hotels: [])
        
        Task {
            await mockModel.fetchHotelsForFilter(filter)
        }
        
        wait(for: [expectation], timeout: 5.0)
        XCTAssertEqual(values, [false, true, false])
    }
    
    func testUserCurrency() {
        XCTAssertEqual(mockModel.userCurrency, "USD")
    }
}
