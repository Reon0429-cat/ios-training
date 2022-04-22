//
//  WeatherPresenter.swift
//  ios-training
//
//  Created by 大西 玲音 on 2022/04/22.
//

import Foundation

protocol WeatherPresenterable {
    func fetchWeather() -> Weatherable?
}

final class WeatherPresenter: WeatherPresenterable {
    
    private let weathers: [Weatherable] = [Sunny(), Rainy(), Cloudy()]
    private let weatherUseCase: WeatherUseCaseProtocol
    
    init(weatherUseCase: WeatherUseCaseProtocol) {
        self.weatherUseCase = weatherUseCase
    }
    
    func fetchWeather() -> Weatherable? {
        let fetchedWeather = weatherUseCase.fetchWeather()
        guard let weather = weathers.first(where: { $0.name == fetchedWeather }) else {
            print("該当する天気がない")
            return nil
        }
        return weather
    }
    
}
