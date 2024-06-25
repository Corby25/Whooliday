//
//  ChartData.swift
//  Whooliday
//
//  Created by Fabio Tagliani on 24/06/24.
//

import Foundation

struct APIResponse: Codable {
    let data: [String: DayData]
}

struct DayData: Codable {
    let daily: Double
    let weekly: Double
    let monthly: Double?
}
