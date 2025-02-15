//
//  WeatherData.swift
//  WeatherApp-ios
//
//  Created by Pranav on 14/02/25.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
    let wind:Wind
}

struct Main: Codable {
    let temp: Double
    let feels_like: Double
    let humidity:Int
}

struct Weather: Codable {
    let main: String
    let description: String
    let id: Int
}

struct Wind:Codable{
    let speed:Double
}
