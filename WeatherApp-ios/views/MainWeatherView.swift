//
//  CurrentWeatherView.swift
//  WeatherApp-ios
//
//  Created by Pranav on 14/02/25.
//
import SwiftUI

@MainActor
class SharedWeatherState: ObservableObject {
    @Published var currentCity: String = ""
}

struct MainWeatherView: View {
    
    @StateObject private var viewModel = WeatherViewModel()
    @StateObject private var sharedState = SharedWeatherState()
    @State private var searchText = ""
    @FocusState private var isSearchFieldFocused: Bool
    
    var body: some View {
        ZStack {
            Image(.background)
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {
                    // Search Bar Section
                    HStack {
                        Button {
                            viewModel.fetchWeatherForCurrentLocation()
                        } label: {
                            Image(systemName: "location.circle.fill")
                                .font(.largeTitle)
                        }
                        
                        TextField("Enter city name", text: $searchText)
                            .focused($isSearchFieldFocused)
                            .frame(maxWidth: 230)
                            .padding()
                            .background(Color.myGray)
                            .cornerRadius(15)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                            .submitLabel(.search)
                            .onSubmit(performSearch)
                        
                        Button(action: performSearch) {
                            Image(systemName: "magnifyingglass")
                                .padding()
                                .background(Color.myGray)
                                .clipShape(Circle())
                        }
                    }
                    .padding(.horizontal)
                    
                    // Current Weather Card
                    WeatherCardView(
                        conditionImage: viewModel.conditionImage,
                        temperature: viewModel.temperature,
                        cityName: viewModel.cityName,
                        humidity: viewModel.currHumidity,
                        windSpeed: viewModel.windSpeed
                    )
                   
                    
              
                    
                    // Hourly Forecast Section
                    VStack(alignment: .leading, spacing: 10) {
                       
                        
                        HourlyWeatherView(searchCityTxt: $searchText)
                            .environmentObject(sharedState)
                    }
                    .padding(.bottom, 20)
                    
                    // Daily Forecast Section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("5-Day Forecast")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.horizontal)
                        
                        DailyWeatherView(searchCityTxt: $searchText)
                            .environmentObject(sharedState)
                          
                    }
                    .padding(.bottom, 30)
                }
            }
        }
    }
    
    private func performSearch() {
        guard !searchText.isEmpty else { return }
        viewModel.fetchWeather(for: searchText)
        sharedState.currentCity = searchText
        searchText = ""
        isSearchFieldFocused = false
    }
}

#Preview {
    MainWeatherView()
}
