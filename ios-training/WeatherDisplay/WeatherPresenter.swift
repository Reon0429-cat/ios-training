//
//  WeatherPresenter.swift
//  ios-training
//
//  Created by 大西 玲音 on 2022/04/22.
//

import Foundation

protocol WeatherPresenterable {
    func fetchWeather() -> WeatherProtocol?
}

final class WeatherPresenter: WeatherPresenterable {
    
    private let weathers: [WeatherProtocol] = [Sunny(), Rainy(), Cloudy()]
    private let weatherUseCase: WeatherUseCaseProtocol
    
    init(weatherUseCase: WeatherUseCaseProtocol) {
        self.weatherUseCase = weatherUseCase
    }
    
    func fetchWeather() -> WeatherProtocol? {
        let fetchedWeather = weatherUseCase.fetchWeather()
        guard let weather = weathers.first(where: { $0.name == fetchedWeather }) else {
            print("該当する天気がない")
            return nil
        }
        return weather
    }
    
}
