//
//  DailyModel.swift
//  WeatherApp-ios
//
//  Created by Pranav on 15/02/25.
//


import Foundation

struct DailyModel: Identifiable {
    let id = UUID()
    let date: String
    let conditionId: Int
    let avgTemp:Double
    
    var conditionName: String {
        return WeatherConditionHelper.getConditionName(for: conditionId)
    }
}
