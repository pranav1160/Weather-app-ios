//
//  WeatherViewModel.swift
//  WeatherApp-ios
//
//  Created by Pranav on 14/02/25.
//

import Foundation
import CoreLocation

@MainActor
class WeatherViewModel: NSObject, ObservableObject, @preconcurrency CLLocationManagerDelegate {
    
    private var weatherManager = WeatherService()
    private var locationManager = CLLocationManager()
    
    @Published var cityName: String = ""
    @Published var temperature: String = "--"
    @Published var conditionImage: String = "cloud.sun"
    @Published var errorMessage: String?
    @Published var currHumidity:String="__"
    @Published var windSpeed:String="__"
    override init() {
        super.init()
        locationManager.delegate = self
        handleLocationAuthorization()
    }
    
    func fetchWeather(for city: String) {
        errorMessage = nil
        Task {
            do {
                let weather = try await weatherManager.fetchData(cityName: city)
                updateWeatherUI(with: weather)
            } catch {
                errorMessage = "Error fetching weather: \(error.localizedDescription)"
            }
        }
    }
    
    func fetchWeatherForCurrentLocation() {
        errorMessage = nil
        handleLocationAuthorization()
    }
    
    // MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            Task {
                do {
                    let weather = try await weatherManager.fetchData(
                        latitude: location.coordinate.latitude,
                        longitude: location.coordinate.longitude
                    )
                    updateWeatherUI(with: weather)
                } catch {
                    errorMessage = "Error fetching weather: \(error.localizedDescription)"
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        errorMessage = "Location Error: \(error.localizedDescription)"
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        handleLocationAuthorization()
    }
    
    private func handleLocationAuthorization() {
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
        case .denied, .restricted:
            errorMessage = "Location access denied. Enable in Settings."
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        @unknown default:
            break
        }
    }
    
    private func updateWeatherUI(with weather: WeatherModel) {
        cityName = weather.cityName
        temperature = "\(weather.temp)"
        conditionImage = weather.conditionName
        currHumidity = "\(weather.humidity)"
        windSpeed = String(format: "%.2f", weather.speed)
    }
}
