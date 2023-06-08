//
//  WeatherModels.swift
//  JPMorgan-Coding-Exercise
//
//  Created by Ammar Chishti on 6/7/23.
//

import Foundation

struct WeatherObject: Codable {
    let coord: Coordinates
    let main: mainInformation
    let weather: [weatherInformation]
}

struct WeatherObjectError: Codable {
    let message: String
}

struct Coordinates: Codable {
    let lon: Double
    let lat: Double
}

struct mainInformation: Codable {
    let temp: Double
    let humidity: Double
}

struct weatherInformation: Codable {
    let main: String
    let description: String
    let icon: String
}
