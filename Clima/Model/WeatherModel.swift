//
//  WeatherModel.swift
//  Clima
//
//  Created by Yick Ming Lee on 09/02/2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation

struct WeatherModel {
    let conditionID: Int
    let cityName: String
    let temperature: Double
    
    var temperature_formatted: String {
        return String(format: "%.1f", temperature)
    }
    
    // Computed property (act like function)
    var conditionName: String {
        switch conditionID {
        case 200...232:
            // Group 2xx: Thunderstorm
            return "cloud.bolt.fill"
        case 300...321:
            // Group 3xx: Drizzle
            return "cloud.drizzle.fill"
        case 500...531:
            // Group 5xx: Rain
            return "cloud.rain.fill"
        case 600...622:
            // Group 6xx: Snow
            return "cloud.snow.fill"
        case 701...781:
            // Group 7xx: Atmosphere
            return "cloud.fog.fill"
        case 800:
            // Group 800: Clear
            return "sun.max.fill"
        case 801...804:
            // Group 80x: Clouds
            return "cloud.fill"
        default:
            return "aqi.low"
        }
    }
    
}
