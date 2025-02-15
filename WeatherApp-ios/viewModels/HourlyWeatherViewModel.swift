//
//  HourlyWeatherViewModel.swift
//  WeatherApp-ios
//
//  Created by Pranav on 15/02/25.
//


//
//  HourlyWeatherViewModel.swift
//  WeatherApp-ios
//
//  Created by Pranav on 15/02/25.
//

import Foundation
import CoreLocation

@MainActor
class HourlyWeatherViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    private let hourlyService = HourlyService()
    private let locationManager = CLLocationManager()
    
    @Published var hourlyWeather: [HourlyModel]? = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    override init() {
        super.init()
        locationManager.delegate = self
        handleLocationAuthorization()
    }
    
    // Fetch hourly weather by city name
    func fetchHourlyWeather(for city: String) {
        errorMessage = nil
        isLoading = true
        Task {
            do {
                let data = try await hourlyService.fetchHourlyData(cityName: city)
                self.hourlyWeather = data
            } catch {
                self.errorMessage = "Error fetching hourly data: \(error.localizedDescription)"
            }
            isLoading = false
        }
    }
    
    // Fetch hourly weather for current location
    func fetchHourlyWeatherForCurrentLocation() {
        errorMessage = nil
        handleLocationAuthorization()
    }
    
    // MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            Task {
                do {
                    let data = try await hourlyService.fetchHourlyData(
                        latitude: location.coordinate.latitude,
                        longitude: location.coordinate.longitude
                    )
                    self.hourlyWeather = data
                } catch {
                    self.errorMessage = "Error fetching hourly data: \(error.localizedDescription)"
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
