//
//  WeatherUseCase.swift
//  ios-training
//
//  Created by 大西 玲音 on 2022/04/22.
//

import Foundation
import YumemiWeather

protocol WeatherUseCaseProtocol {
    func fetchWeather() -> WeatherType?
}

final class WeatherUseCase: WeatherUseCaseProtocol {

    func fetchWeather() -> WeatherType?  {
        let fetchedYumemiWeather = YumemiWeather.fetchWeather()
        guard let weather = WeatherType(rawValue: fetchedYumemiWeather) else {
            return nil
        }
        return weather
    }
    
}