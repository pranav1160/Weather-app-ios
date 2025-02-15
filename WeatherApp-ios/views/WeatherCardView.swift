//
//  WeatherCardView.swift
//  WeatherApp-ios
//
//  Created by Pranav on 14/02/25.
//

import SwiftUI

struct WeatherCardView: View {
    let conditionImage: String
    let temperature: String
    let cityName: String
    let humidity: String
    let windSpeed: String
    
    var body: some View {
        ZStack {
            // Card background with gradient and rounded corners
            RoundedRectangle(cornerRadius: 25)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            .darkGreen, // #99D1D3
                            .mediumGreen, // #65A6AB
                            .darkGreen  // #1C4348
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .shadow(radius: 10)
            
            VStack(spacing: 15) {
                // Weather icon
                Image(systemName: conditionImage)
                    .font(.system(size: 60))
                    .symbolRenderingMode(.multicolor)
                
                // Temperature text
                Text(temperature)
                    .font(.system(size: 50, weight: .bold))
                    .foregroundColor(.white)
                
                // City name
                Text(cityName)
                    .font(.title2)
                    .foregroundColor(.white)
                
                // Additional weather details
                HStack {
                    VStack {
                        Text("Humidity")
                            .font(.caption)
                            .foregroundColor(.white)
                        Text("\(humidity)%")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 20)
                    
                    VStack {
                        Text("Wind")
                            .font(.caption)
                            .foregroundColor(.white)
                        Text("\(windSpeed) km/h")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.top, 10)
            }
            .padding()
        }
        .frame(maxWidth: 320, maxHeight: 300)
        .padding()
    }
}

struct WeatherCardView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherCardView(
            conditionImage: "sun.max.fill",
            temperature: "25°",
            cityName: "San Francisco",
            humidity: "60",
            windSpeed: "10"
        )
        .previewLayout(.sizeThatFits)
    }
}
