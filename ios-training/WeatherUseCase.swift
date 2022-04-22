//
//  WeatherUseCase.swift
//  ios-training
//
//  Created by 大西 玲音 on 2022/04/22.
//

import Foundation
import YumemiWeather

protocol WeatherUseCaseProtocol {
    func fetchWeather() -> WeatherProtocol?
}

final class WeatherUseCase: WeatherUseCaseProtocol {
    
    private let weathers: [WeatherProtocol] = [Sunny(), Rainy(), Cloudy()]

    // 一旦、同期処理のみ実装しておく
    func fetchWeather() -> WeatherProtocol?  {
        let fetchedYumemiWeather = YumemiWeather.fetchWeather()
        guard let weather = weathers.first(where: { $0.name == fetchedYumemiWeather }) else {
            return nil
        }
        return weather
    }
    
}
