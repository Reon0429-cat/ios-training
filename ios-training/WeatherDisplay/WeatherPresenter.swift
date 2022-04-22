//
//  WeatherPresenter.swift
//  ios-training
//
//  Created by 大西 玲音 on 2022/04/22.
//

import Foundation

protocol WeatherPresentable {
    func fetchWeather() -> WeatherProtocol?
}

final class WeatherPresenter: WeatherPresentable {
    
    private let weatherUseCase: WeatherUseCaseProtocol
    
    init(weatherUseCase: WeatherUseCaseProtocol) {
        self.weatherUseCase = weatherUseCase
    }
    
    func fetchWeather() -> WeatherProtocol? {
        let fetchedWeather = weatherUseCase.fetchWeather()
        return fetchedWeather
    }
    
}
