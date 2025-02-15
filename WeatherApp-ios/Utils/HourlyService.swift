//
//  HourlyService.swift
//  WeatherApp-ios
//
//  Created by Pranav on 15/02/25.
//


//
//  HourlyService.swift
//  WeatherApp-ios
//
//  Created by Pranav on 15/02/25.
//

import Foundation

class HourlyService {
    private let baseURL = "https://api.openweathermap.org/data/2.5/forecast?appid=12e4d1c38921edcd381ab580ea6147b8&units=metric"

    // Fetch hourly forecast by city name
    func fetchHourlyData(cityName: String) async throws -> [HourlyModel] {
        guard let encodedCity = cityName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            throw URLError(.badURL)
        }
        let urlString = "\(baseURL)&q=\(encodedCity)"
        return try await performRequest(with: urlString)
    }

    // Fetch hourly forecast by coordinates
    func fetchHourlyData(latitude: Double, longitude: Double) async throws -> [HourlyModel] {
        let urlString = "\(baseURL)&lat=\(latitude)&lon=\(longitude)"
        return try await performRequest(with: urlString)
    }

    private func performRequest(with urlString: String) async throws -> [HourlyModel] {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        return try parseJSON(data)
    }

    private func parseJSON(_ data: Data) throws -> [HourlyModel] {
        let decoder = JSONDecoder()
        let decodedData = try decoder.decode(HourlyData.self, from: data)

        return decodedData.list.map { entry in
            HourlyModel(
                time: entry.time,
                conditionId: entry.weather.first?.id ?? 800, // Default to clear sky
                temperature: entry.main.temp
            )
        }
    }
}
