//
//  WeatherConditionHelper.swift
//  WeatherApp-ios
//
//  Created by Pranav on 15/02/25.
//


struct WeatherConditionHelper {
    static func getConditionName(for conditionId: Int) -> String {
        switch conditionId {
        case 200...232:
            return "cloud.bolt.rain"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
}
