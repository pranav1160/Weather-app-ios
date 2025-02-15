//
//  ForecastData.swift
//  WeatherApp-ios
//
//  Created by Pranav on 15/02/25.
//

import Foundation

// MARK: - Models
struct DailyData: Codable {
    let list: [ForecastItem]
}

struct ForecastItem: Codable {
    let dt_txt: String
    let main: MyMain
    let weather: [MyWeather]
}

struct MyMain: Codable {
    let temp: Double
}

struct MyWeather: Codable {
    let id: Int
}

