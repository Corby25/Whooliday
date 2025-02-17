//
//  User.swift
//  Whooliday
//
//  Created by Tommaso Diegoli on 19/06/24.
//

import Foundation


// user's data structure
struct User: Identifiable, Codable {
    let id: String
    let name: String
    let email: String
    let currency: String
    let locale: String
    let numNotifications: Int
    let numFavorites: Int
    let sendEmail: Bool
    
    var initials: String {
        let formatter =  PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: name) {
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        return ""
    }
}
