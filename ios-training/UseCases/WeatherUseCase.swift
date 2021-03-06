//
//  WeatherUseCase.swift
//  ios-training
//
//  Created by 大西 玲音 on 2022/04/22.
//

import Foundation
import YumemiWeather

protocol WeatherUseCaseProtocol {
    func fetchWeatherItems() async throws -> [WeatherItem]
    func fetchWeather(at area: String) async throws -> Weather
}

enum WeatherFetchError: LocalizedError {
    case failedConvertJsonToData
    case failedConvertDataToJson
    case failedEncoding
    case failedDecoding
    case failedToGetArea
    case apiError(YumemiWeatherError)
    var errorDescription: String? {
        switch self {
        case .failedConvertJsonToData:
            return "JSONからデータの変換に失敗しました。"
        case .failedConvertDataToJson:
            return "データからJSONの変換に失敗しました。"
        case .failedEncoding:
            return "エンコードに失敗しました。"
        case .failedDecoding:
            return "デコードに失敗しました。"
        case .failedToGetArea:
            return "エリアの取得に失敗しました。"
        case .apiError(let error):
            switch error {
            case .invalidParameterError:
                return "無効なパラメーターエラーが発生しました。"
            case .unknownError:
                return "予期しないエラーが発生しました。"
            }
        }
    }
}

final class WeatherUseCase: WeatherUseCaseProtocol {
    
    func fetchWeatherItems() async throws -> [WeatherItem] {
        let areas = Area.allCases.map { $0.rawValue }
        let weatherRequest = WeatherListRequest(areas: areas, date: Date())
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        guard let requestData = try? encoder.encode(weatherRequest) else {
            throw WeatherFetchError.failedEncoding
        }
        guard let jsonString = String(data: requestData, encoding: .utf8) else {
            throw WeatherFetchError.failedConvertDataToJson
        }
        let fetchedJson = try await YumemiWeather.asyncFetchWeatherList(jsonString)
        guard let fetchedJsonData = fetchedJson.data(using: .utf8) else {
            throw WeatherFetchError.failedConvertJsonToData
        }
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let weatherItems = try? decoder.decode([WeatherItem].self, from: fetchedJsonData) else {
            throw WeatherFetchError.failedDecoding
        }
        return weatherItems
    }
    
    func fetchWeather(at area: String) async throws -> Weather {
        let weatherRequest = WeatherRequest(area: area, date: Date())
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        guard let requestData = try? encoder.encode(weatherRequest) else {
            throw WeatherFetchError.failedEncoding
        }
        guard let jsonString = String(data: requestData, encoding: .utf8) else {
            throw WeatherFetchError.failedConvertDataToJson
        }
        let fetchedJson = try await YumemiWeather.asyncFetchWeather(jsonString)
        guard let fetchedJsonData = fetchedJson.data(using: .utf8) else {
            throw WeatherFetchError.failedConvertJsonToData
        }
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let weather = try? decoder.decode(Weather.self, from: fetchedJsonData) else {
            throw WeatherFetchError.failedDecoding
        }
        return weather
    }
    
}
