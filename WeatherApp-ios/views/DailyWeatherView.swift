//
//  DailyWeatherView.swift
//  WeatherApp-ios
//
//  Created by Pranav on 15/02/25.
//


import SwiftUI

struct DailyWeatherView: View {
    @StateObject private var viewModel = DailyWeatherViewModel()
    @EnvironmentObject private var sharedState: SharedWeatherState
    @Binding var searchCityTxt: String
    
    var body: some View {
        VStack(spacing: 20) {
           
            
            if viewModel.isLoading {
                ProgressView()
                    .tint(.white)
            } else if let dailyWeather = viewModel.dailyWeather {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 15) {
                        ForEach(dailyWeather) { day in
                            DailyWeatherRow(dailyModel: day)
                        }
                    }
                    .padding(.horizontal)
                }
            } else if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .onChange(of: sharedState.currentCity) { newCity in
            if !newCity.isEmpty {
                viewModel.fetchDailyWeather(for: newCity)
            }
        }
        .onAppear {
            if !searchCityTxt.isEmpty {
                viewModel.fetchDailyWeather(for: searchCityTxt)
            } else {
                viewModel.fetchDailyWeatherForCurrentLocation()
            }
        }
    }
}

struct DailyWeatherRow: View {
    let dailyModel: DailyModel
    
    var body: some View {
        HStack {
            Text(formatDate(dailyModel.date))
                .frame(width: 100, alignment: .leading)
                .foregroundColor(.black)
          
            
            Spacer()
            
            
            Image(systemName: dailyModel.conditionName)
                .symbolRenderingMode(.multicolor)
                .font(.title2)
                .frame(width: 50)
            
            Text(String(format: "%.1f°", dailyModel.avgTemp))
                .foregroundColor(.black)
                .frame(width: 60, alignment: .trailing)
        }
        .padding()
        .background(Color.myGray.opacity(0.6))
        .cornerRadius(15)
        .frame(width: 350)
    }
    
    private func formatDate(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = dateFormatter.date(from: dateString) else {
            return dateString
        }
        
        dateFormatter.dateFormat = "EEE, MMM d"
        return dateFormatter.string(from: date)
    }
}

// Preview provider
struct DailyWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            DailyWeatherView(searchCityTxt: .constant("London"))
                .environmentObject(SharedWeatherState())
        }
    }
}
