//
//  WeatherService.swift
//  Whooliday
//
//  Created by Fabio Tagliani on 04/07/24.
//

import Foundation

struct WeatherService {
    private let baseURL = "https://archive-api.open-meteo.com/v1/archive"

    func fetchWeatherData(latitude: Double, longitude: Double) async throws -> WeatherResponse {
        let currentDate = Date()
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: currentDate)
        let startDate = "\(currentYear - 5)-01-01"  // 5 anni fa
        let endDate = "\(currentYear-1)-12-31"  // Fine dell'anno corrente
        
        let urlString = "\(baseURL)?latitude=\(latitude)&longitude=\(longitude)&start_date=\(startDate)&end_date=\(endDate)&daily=temperature_2m_mean&timezone=auto"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        print(url)

        let (data, _) = try await URLSession.shared.data(from: url)
        
        let decoder = JSONDecoder()
        let response = try decoder.decode(WeatherResponse.self, from: data)
        return response
    }

    func calculateMonthlyAverages(from response: WeatherResponse) -> [MonthlyTemperature] {
        let groupedByMonth = Dictionary(grouping: zip(response.daily.time, response.daily.temperature_2m_mean)) { dateString, _ in
            let components = dateString.split(separator: "-")
            return Int(components[1])!
        }
        
        let monthlyAverages = groupedByMonth.map { (month, temperatures) -> MonthlyTemperature in
            let validTemperatures = temperatures.compactMap { $0.1 }
            let averageTemp = validTemperatures.reduce(0.0, +) / Double(validTemperatures.count)
            return MonthlyTemperature(month: month, temperature: averageTemp)
        }.sorted { $0.month < $1.month }

        return monthlyAverages
    }
}

struct WeatherResponse: Codable {
    let latitude: Double
    let longitude: Double
    let generationtime_ms: Double
    let utc_offset_seconds: Int
    let timezone: String
    let timezone_abbreviation: String
    let elevation: Double
    let daily_units: DailyUnits
    let daily: DailyData
    let error: Bool?
    let reason: String?
}

struct DailyUnits: Codable {
    let time: String
    let temperature_2m_mean: String
}

struct DailyData: Codable {
    let time: [String]
    let temperature_2m_mean: [Double?]
}

struct MonthlyTemperature: Identifiable {
    let id = UUID()
    let month: Int
    let temperature: Double
    
    var monthName: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.monthSymbols[month - 1]
    }
}

// Extension to make working with the data easier
extension Array where Element == MonthlyTemperature {
    func averageTemperature() -> Double {
        let sum = self.reduce(0.0) { $0 + $1.temperature }
        return sum / Double(self.count)
    }
    
    func hottestMonth() -> MonthlyTemperature? {
        return self.max(by: { $0.temperature < $1.temperature })
    }
    
    func coldestMonth() -> MonthlyTemperature? {
        return self.min(by: { $0.temperature < $1.temperature })
    }
}
