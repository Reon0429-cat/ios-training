//
//  WeatherUseCaseStub.swift
//  ios-training
//
//  Created by 大西 玲音 on 2022/05/10.
//

import Foundation
@testable import ios_training

final class WeatherUseCaseStub: WeatherUseCaseProtocol {
    
    let weather: Weather
    init(weather: Weather) {
        self.weather = weather
    }
    
    func fetchWeather() throws -> Weather {
        weather
    }
    
}
