//
//  Weather.swift
//  ios-training
//
//  Created by 大西 玲音 on 2022/04/27.
//

import Foundation

struct WeatherItem: Decodable {
    let info: Weather
    let area: String
}

struct Weather: Decodable {
    let maxTemp: Int
    let minTemp: Int
    let weather: String
}
