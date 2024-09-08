//
//  WeatherResponce.swift
//  
//
//  Created by Дмитрий Мартьянов on 06.09.2024.
//

import Foundation

struct WeatherResponce: Decodable {
    let weather: [Weather]
    let main: Main
}
struct Weather: Decodable {
    let description: String
    let icon: String
}
struct Main: Decodable {
    let temp: Double
    let temp_min: Double
    let temp_max: Double
}
