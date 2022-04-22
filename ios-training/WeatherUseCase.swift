//
//  WeatherUseCase.swift
//  ios-training
//
//  Created by 大西 玲音 on 2022/04/22.
//

import Foundation
import YumemiWeather

protocol WeatherUseCaseProtocol {
    // 一旦、同期処理のみ実装しておく
    func fetchWeather() -> String
}

final class WeatherUseCase: WeatherUseCaseProtocol {
    
    func fetchWeather() -> String {
        let fetchedWeather = YumemiWeather.fetchWeather()
        return fetchedWeather
    }
    
}
