//
//  DailyService.swift
//  WeatherApp-ios
//
//  Created by Pranav on 15/02/25.
//

import Foundation

class DailyService {
    private let baseURL = "https://api.openweathermap.org/data/2.5/forecast?appid=12e4d1c38921edcd381ab580ea6147b8&units=metric"
    
    
    // Fetch daily forecast by city name
    func fetchDailyData(cityName: String) async throws -> [DailyModel] {
        guard let encodedCity = cityName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            throw URLError(.badURL)
        }
        let urlString = "\(baseURL)&q=\(encodedCity)"
        return try await performRequest(with: urlString)
    }
    
    
    // Fetch daily forecast by coordinates
    func fetchDailyData(latitude: Double, longitude: Double) async throws -> [DailyModel] {
        let urlString = "\(baseURL)&lat=\(latitude)&lon=\(longitude)"
        return try await performRequest(with: urlString)
    }
    
    
    private func performRequest(with urlString: String) async throws -> [DailyModel] {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        return try parseJSON(data)
    }
    
    
    private func parseJSON(_ data: Data) throws -> [DailyModel] {
        let decoder = JSONDecoder()
        let decodedData = try decoder.decode(DailyData.self, from: data)
        
        // Group forecast items by date (assuming dt_txt is in format "YYYY-MM-DD HH:mm:ss")
        let groupedByDate = Dictionary(grouping: decodedData.list) { item in
            String(item.dt_txt.prefix(10)) // Get just the date part
        }
        
        // Create daily models from grouped data
        return groupedByDate.map { date, items in
            // Calculate average temperature for the day
            let avgTemp = items.reduce(0.0) { $0 + $1.main.temp } / Double(items.count)
            
            // Use the most common weather condition ID for the day
            let conditionIdCounts = items.reduce(into: [Int: Int]()) { counts, item in
                if let weatherId = item.weather.first?.id {
                    counts[weatherId, default: 0] += 1
                }
            }
            let mostCommonConditionId = conditionIdCounts.max(by: { $0.value < $1.value })?.key ?? 800
            
            return DailyModel(
                date: date,
                conditionId: mostCommonConditionId,
                avgTemp: avgTemp
            )
        }.sorted { $0.date < $1.date }
    }
}
