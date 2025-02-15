//
//  WeatherModel.swift
//  WeatherApp-ios
//
//  Created by Pranav on 14/02/25.
//
import Foundation

struct WeatherModel {
    let conditionId: Int
    let cityName: String
    let temp: Double
    let humidity:Int
    let speed:Double
    
    var conditionName: String {
        return WeatherConditionHelper.getConditionName(for: conditionId)
    }
}
