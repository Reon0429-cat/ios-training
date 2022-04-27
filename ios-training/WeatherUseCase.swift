//
//  WeatherUseCase.swift
//  ios-training
//
//  Created by 大西 玲音 on 2022/04/22.
//

import Foundation
import YumemiWeather

protocol WeatherUseCaseProtocol {
    func fetchWeather() throws -> Weather
}

enum WeatherFetchError: LocalizedError {
    case failedConversionJson
    case apiError(YumemiWeatherError)
    var errorDescription: String? {
        switch self {
        case .failedConversionJson:
            return "JSONの変換に失敗しました。"
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
    
    func fetchWeather() throws -> Weather {
        do {
            let sampleJson = """
                             {
                                "area": "tokyo",
                                "date": "2022-04-027T12:10:00+09:00"
                             }
                             """
            let fetchedJson = try YumemiWeather.fetchWeather(sampleJson)
            guard let fetchedJsonData = fetchedJson.data(using: .utf8) else {
                throw WeatherFetchError.failedConversionJson
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let weather = try decoder.decode(Weather.self, from: fetchedJsonData)
            return weather
        } catch let error as YumemiWeatherError {
            throw WeatherFetchError.apiError(error)
        }
    }
    
}
