//
//  WeatherService.swift
//  WeatherApp-ios
//
//  Created by Pranav on 14/02/25.
//


import Foundation

class WeatherService {
    private let baseURL = "https://api.openweathermap.org/data/2.5/weather?appid=12e4d1c38921edcd381ab580ea6147b8&units=metric"
    
    func fetchData(cityName: String) async throws -> WeatherModel {
        guard let encodedCity = cityName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            throw URLError(.badURL)
        }
        let urlString = "\(baseURL)&q=\(encodedCity)"
        return try await performRequest(with: urlString)
    }
    
    func fetchData(latitude: Double, longitude: Double) async throws -> WeatherModel {
        let urlString = "\(baseURL)&lat=\(latitude)&lon=\(longitude)"
        return try await performRequest(with: urlString)
    }
    
    private func performRequest(with urlString: String) async throws -> WeatherModel {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        return try parseJSON(data)
    }
    
    private func parseJSON(_ data: Data) throws -> WeatherModel {
        let decoder = JSONDecoder()
        let decodedData = try decoder.decode(WeatherData.self, from: data)
        
        guard let weatherCondition = decodedData.weather.first else {
            throw URLError(.cannotParseResponse)
        }
        
        return WeatherModel(
            conditionId: weatherCondition.id,
            cityName: decodedData.name,
            temp: decodedData.main.temp,
            humidity: decodedData.main.humidity,
            speed: decodedData.wind.speed
        )
    }
}
