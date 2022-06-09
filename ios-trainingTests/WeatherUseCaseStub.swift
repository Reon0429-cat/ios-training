//
//  WeatherUseCaseStub.swift
//  ios-training
//
//  Created by 大西 玲音 on 2022/05/10.
//

import Foundation
@testable import ios_training

final class WeatherUseCaseStub: WeatherUseCaseProtocol {

    let weatherItem: WeatherItem
    
    init(weatherItem: WeatherItem) {
        self.weatherItem = weatherItem
    }
    
    func fetchWeatherItems() async throws -> [WeatherItem] {
        return [weatherItem]
    }
    
    func fetchWeather(at area: String) async throws -> Weather {
        return weatherItem.info
    }

}
