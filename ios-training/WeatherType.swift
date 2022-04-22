//
//  WeatherType.swift
//  ios-training
//
//  Created by 大西 玲音 on 2022/04/22.
//

import Foundation

enum WeatherType: CaseIterable {
    case sunny
    case rainy
    case cloudy
    var name: String {
        switch self {
        case .sunny:
            return "sunny"
        case .rainy:
            return "rainy"
        case .cloudy:
            return "cloudy"
        }
    }
}
