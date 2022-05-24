//
//  WeatherUseCase.swift
//  ios-training
//
//  Created by 大西 玲音 on 2022/04/22.
//

import Foundation
import YumemiWeather

protocol WeatherUseCaseProtocol: AnyObject {
    func fetchWeather()
    var delegate: WeatherUseCaseDelegate? { get }
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

protocol WeatherUseCaseDelegate: AnyObject {
    func didFetchedWeather(weather: Weather)
    func didFailedWithError(error: Error)
}

final class WeatherUseCase: WeatherUseCaseProtocol {
    
    weak var delegate: WeatherUseCaseDelegate?
    
    func fetchWeather() {
        DispatchQueue.global().async {
            let weatherRequest = WeatherRequest(area: "tokyo", date: Date())
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            guard let requestData = try? encoder.encode(weatherRequest) else {
                self.delegate?.didFailedWithError(error: WeatherFetchError.failedEncoding)
                return
            }
            guard let jsonString = String(data: requestData, encoding: .utf8) else {
                self.delegate?.didFailedWithError(error: WeatherFetchError.failedConvertDataToJson)
                return
            }
            let fetchedJson: String
            do {
                fetchedJson = try YumemiWeather.syncFetchWeather(jsonString)
            } catch let error as YumemiWeatherError {
                self.delegate?.didFailedWithError(error: error)
                return
            } catch {
                self.delegate?.didFailedWithError(error: error)
                return
            }
            guard let fetchedJsonData = fetchedJson.data(using: .utf8) else {
                self.delegate?.didFailedWithError(error: WeatherFetchError.failedConvertJsonToData)
                return
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            guard let weather = try? decoder.decode(Weather.self, from: fetchedJsonData) else {
                self.delegate?.didFailedWithError(error: WeatherFetchError.failedDecoding)
                return
            }
            self.delegate?.didFetchedWeather(weather: weather)
        }
    }
    
}
