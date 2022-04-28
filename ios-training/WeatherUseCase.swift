//
//  WeatherUseCase.swift
//  ios-training
//
//  Created by 大西 玲音 on 2022/04/22.
//

import Foundation
import YumemiWeather

protocol WeatherUseCaseProtocol {
    func fetchWeather() throws -> WeatherType
}

enum WeatherFetchError: Error {
    case notFound
    var errorText: String {
        switch self {
        case .notFound:
            return "天気が見つかりませんでした。"
        }
    }
}

final class WeatherUseCase: WeatherUseCaseProtocol {

    func fetchWeather() throws -> WeatherType {
        let fetchedYumemiWeather = try YumemiWeather.fetchWeather(at: "tokyo")
        guard let weather = WeatherType(rawValue: fetchedYumemiWeather) else {
            throw WeatherFetchError.notFound
        }
        return weather
    }
    
}
