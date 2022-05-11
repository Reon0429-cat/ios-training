//
//  ios_trainingTests.swift
//  ios-trainingTests
//
//  Created by 大西 玲音 on 2022/04/22.
//

import XCTest
@testable import ios_training

final class ios_trainingTests: XCTestCase {
    
    private var weatherDisplayViewController: WeatherDisplayViewController!
    private enum TestError: Error {
        case failedGetWeatherImage
        case failedGetMaxWeatherText
        case failedGetMinWeatherText
    }
    
    func test天気予報がsunnyだったら画面に晴れ画像が表示されること() throws {
        let sunnyWeather = Weather(maxTemp: 10, minTemp: 0, weather: "sunny")
        setupWeatherDisplay(weather: sunnyWeather)
        guard let image = weatherDisplayViewController.weatherImageView?.image else {
            throw TestError.failedGetWeatherImage
        }
        XCTAssertEqual(image, UIImage(named: "sunny"))
    }
    
    func test天気予報がcloudyだったら画面に曇り画像が表示されること() throws {
        let cloudyWeather = Weather(maxTemp: 10, minTemp: 0, weather: "cloudy")
        setupWeatherDisplay(weather: cloudyWeather)
        guard let image = weatherDisplayViewController.weatherImageView?.image else {
            throw TestError.failedGetWeatherImage
        }
        XCTAssertEqual(image, UIImage(named: "cloudy"))
    }
    
    func test天気予報がrainyだったら画面に雨画像が表示されること() throws {
        let rainyWeather = Weather(maxTemp: 10, minTemp: 0, weather: "rainy")
        setupWeatherDisplay(weather: rainyWeather)
        guard let image = weatherDisplayViewController.weatherImageView?.image else {
            throw TestError.failedGetWeatherImage
        }
        XCTAssertEqual(image, UIImage(named: "rainy"))
    }
    
    func test天気予報の最高気温がUILabelに反映されること() throws {
        let weather = Weather(maxTemp: 10, minTemp: 0, weather: "sunny")
        setupWeatherDisplay(weather: weather)
        guard let maxTempText = weatherDisplayViewController.maxTemperatureLabel.text else {
            throw TestError.failedGetMaxWeatherText
        }
        XCTAssertEqual(maxTempText, "10")
    }
    
    func test天気予報の最低気温がUILabelに反映されること() throws {
        let weather = Weather(maxTemp: 10, minTemp: 0, weather: "sunny")
        setupWeatherDisplay(weather: weather)
        guard let minTempText = weatherDisplayViewController.minTemperatureLabel.text else {
            throw TestError.failedGetMinWeatherText
        }
        XCTAssertEqual(minTempText, "0")
    }
    
    private func setupWeatherDisplay(weather: Weather) {
        let weatherUseCaseStub = WeatherUseCaseStub(weather: weather)
        weatherDisplayViewController = WeatherDisplayViewController.instantiate(
            weatherUseCase: weatherUseCaseStub
        )
        weatherDisplayViewController.loadViewIfNeeded()
    }
    
}
