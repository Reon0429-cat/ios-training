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

    // 一旦、同期処理のみ実装しておく
    func fetchWeather() -> WeatherType?  {
        let fetchedYumemiWeather = YumemiWeather.fetchWeather()
        let weathers = WeatherType.allCases
        guard let weather = weathers.first(where: { $0.name == fetchedYumemiWeather }) else {
            return nil
        }
        return weather
    }
    
}
