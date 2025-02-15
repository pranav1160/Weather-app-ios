//
//  DailyWeatherViewModel.swift
//  WeatherApp-ios
//
//  Created by Pranav on 15/02/25.
//

import Foundation
import CoreLocation

@MainActor
class DailyWeatherViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    private let dailyService = DailyService()
    private let locationManager = CLLocationManager()
    
    @Published var dailyWeather: [DailyModel]? = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    override init() {
        super.init()
        locationManager.delegate = self
        handleLocationAuthorization()
    }
    
    // Fetch daily weather by city name
    func fetchDailyWeather(for city: String) {
        errorMessage = nil
        isLoading = true
        Task {
            do {
                let data = try await dailyService.fetchDailyData(cityName: city)
                self.dailyWeather = data
            } catch {
                self.errorMessage = "Error fetching daily forecast: \(error.localizedDescription)"
            }
            isLoading = false
        }
    }
    
    // Fetch daily weather for current location
    func fetchDailyWeatherForCurrentLocation() {
        errorMessage = nil
        handleLocationAuthorization()
    }
    
    // MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            Task {
                do {
                    let data = try await dailyService.fetchDailyData(
                        latitude: location.coordinate.latitude,
                        longitude: location.coordinate.longitude
                    )
                    self.dailyWeather = data
                } catch {
                    self.errorMessage = "Error fetching daily forecast: \(error.localizedDescription)"
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
}
