//
//  Model.swift
//  BountyHunter
//
//  Created by Ángel González on 11/11/23.
//


import Foundation

// MARK: - Fugitive
struct Fugitive: Codable {
    let gender: Gender
    let bounty, fugitiveid: Int
    let name: String
    let age: Int
    let desc: String
    let lastSeenLat : Double
    let lastSeenLon : Double
    let capturedLat : Double
    let capturedLon : Double

    enum CodingKeys: String, CodingKey {
        case gender = "GENDER"
        case bounty = "BOUNTY"
        case fugitiveid = "FUGITIVEID"
        case name = "NAME"
        case age = "AGE"
        case desc = "DESC"
        case lastSeenLat = "LAST_SEEN_LAT"
        case lastSeenLon = "LAST_SEEN_LON"
        case capturedLat = "CAPTURED_LAT"
        case capturedLon = "CAPTURED_LON"
    }
}

enum Gender: String, Codable {
    case female = "Female"
    case male = "Male"
}

typealias Fugitives = [Fugitive]
