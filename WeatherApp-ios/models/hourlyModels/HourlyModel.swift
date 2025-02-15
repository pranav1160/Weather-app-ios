//
//  HourlyModel.swift
//  WeatherApp-ios
//
//  Created by Pranav on 15/02/25.
//



import Foundation

struct HourlyModel {
    let id = UUID()
    let time: String
    let conditionId: Int
    let temperature: Double
    
    var conditionName: String {
        return WeatherConditionHelper.getConditionName(for: conditionId)
    }
    
}
