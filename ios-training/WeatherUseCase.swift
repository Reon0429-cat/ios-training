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
    case failedConvertJsonToData
    case failedConvertDataToJson
    case apiError(YumemiWeatherError)
    var errorDescription: String? {
        switch self {
        case .failedConvertJsonToData:
            return "JSONからデータの変換に失敗しました。"
        case .failedConvertDataToJson:
            return "データからJSONの変換に失敗しました。"
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
            let weatherRequest = WeatherRequest(area: "tokyo", date: Date())
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let requestData = try encoder.encode(weatherRequest)
            guard let jsonString = String(data: requestData, encoding: .utf8) else {
                throw WeatherFetchError.failedConvertDataToJson
            }
            let fetchedJson = try YumemiWeather.fetchWeather(jsonString)
            guard let fetchedJsonData = fetchedJson.data(using: .utf8) else {
                throw WeatherFetchError.failedConvertJsonToData
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
