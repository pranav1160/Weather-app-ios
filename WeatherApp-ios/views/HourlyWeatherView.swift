//
//  HourlyWeatherView.swift
//  WeatherApp-ios
//
//  Created by Pranav on 15/02/25.
//


import SwiftUI

struct HourlyWeatherView: View {
    @StateObject private var viewModel = HourlyWeatherViewModel()
    @Binding var searchCityTxt: String
    @EnvironmentObject private var sharedState: SharedWeatherState
    
    var body: some View {
        VStack (){
         
            if viewModel.isLoading {
                ProgressView()
                    .padding()
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            } else if let hourlyData = viewModel.hourlyWeather, !hourlyData.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(hourlyData, id: \.id) { hour in
                            HourlyWeatherCard(hour: hour)
                        }
                    }
                    .padding(.horizontal)
                }
            } else {
                Text("No hourly data available")
                    .foregroundColor(.secondary)
                    .padding()
            }
        }
        .onChange(of: sharedState.currentCity) { newCity in
            if !newCity.isEmpty {
                viewModel.fetchHourlyWeather(for: newCity)
            }
        }
    }
}


struct HourlyWeatherCard: View {
    let hour: HourlyModel
    
    var body: some View {
        VStack(spacing: 5) {
            Text(hour.time)
                .font(.subheadline)
                .foregroundColor(.primary)
            Image(systemName: hour.conditionName)
                .font(.largeTitle)
                .symbolRenderingMode(.multicolor)
            Text(String(format: "%.1f°C", hour.temperature))
                .font(.subheadline)
                .foregroundColor(.primary)
        }
        .frame(width: 80, height: 120)
        .background(Color.white.opacity(0.5))
        .cornerRadius(15)
        .shadow(radius: 2)
    }
}

#Preview {
    HourlyWeatherView(searchCityTxt: .constant(""))
        .environmentObject(SharedWeatherState())
}
