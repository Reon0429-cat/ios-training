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
    case apiError(YumemiWeatherError)
    var errorText: String {
        switch self {
        case .apiError(let error):
            switch error {
            case .invalidParameterError:
                return "無効なパラメータエラーが発生しました。"
            case .unknownError:
                return "予期しないエラーが発生しました。"
            }
        }
    }
}

final class WeatherUseCase: WeatherUseCaseProtocol {

    func fetchWeather() throws -> WeatherType {
        do {
            let fetchedYumemiWeather = try YumemiWeather.fetchWeather(at: "tokyo")
            guard let weather = WeatherType(rawValue: fetchedYumemiWeather) else {
                fatalError("想定外の天気が発生しました。")
            }
            return weather
        } catch let error as YumemiWeatherError {
            throw WeatherFetchError.apiError(error)
        }
    }
    
}
