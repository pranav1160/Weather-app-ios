//
//  WeatherResponse.swift
//  WeatherApp-ios
//
//  Created by Pranav on 15/02/25.
//

import Foundation

// Main response structure
struct HourlyData: Codable {
    let list: [WeatherEntry]
}

// Individual weather entry
struct WeatherEntry: Codable {
    let dt_txt: String  // Readable date-time string from API
    let main: MainWeather
    let weather: [WeatherCondition]
    
    // Computed property to extract time from `dt_txt`
    var time: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"  // Format of `dt_txt` from API
        formatter.timeZone = TimeZone.current  // Ensure correct timezone
        
        if let date = formatter.date(from: dt_txt) {
            formatter.dateFormat = "hh:mm a"  // Convert to "06:00 AM" format
            return formatter.string(from: date)
        }
        return dt_txt  // Fallback: return the original string if parsing fails
    }
}

// Temperature details
struct MainWeather: Codable {
    let temp: Double  // Temperature in °C
}

// Weather condition details
struct WeatherCondition: Codable {
    let id: Int
}
