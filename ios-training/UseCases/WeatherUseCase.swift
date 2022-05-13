//
//  WeatherUseCase.swift
//  ios-training
//
//  Created by 大西 玲音 on 2022/04/22.
//

import Foundation
import YumemiWeather

protocol WeatherUseCaseProtocol {
    func fetchWeather(completion: ResultHandler<Weather>?)
}

enum WeatherFetchError: LocalizedError {
    case failedConvertJsonToData
    case failedConvertDataToJson
    case failedEncoding
    case failedDecoding
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

typealias ResultHandler<T> = (Result<T, Error>) -> Void

final class WeatherUseCase: WeatherUseCaseProtocol {
    
    func fetchWeather(completion: ResultHandler<Weather>?) {
        DispatchQueue.global().async {
            let weatherRequest = WeatherRequest(area: "tokyo", date: Date())
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            guard let requestData = try? encoder.encode(weatherRequest) else {
                completion?(.failure(WeatherFetchError.failedEncoding))
                return
            }
            guard let jsonString = String(data: requestData, encoding: .utf8) else {
                completion?(.failure(WeatherFetchError.failedConvertDataToJson))
                return
            }
            let fetchedJson: String
            do {
                fetchedJson = try YumemiWeather.syncFetchWeather(jsonString)
            } catch let error as YumemiWeatherError {
                completion?(.failure(error))
                return
            } catch {
                completion?(.failure(error))
                return
            }
            guard let fetchedJsonData = fetchedJson.data(using: .utf8) else {
                completion?(.failure(WeatherFetchError.failedConvertJsonToData))
                return
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            guard let weather = try? decoder.decode(Weather.self, from: fetchedJsonData) else {
                completion?(.failure(WeatherFetchError.failedDecoding))
                return
            }
            completion?(.success(weather))
        }
    }
    
}
