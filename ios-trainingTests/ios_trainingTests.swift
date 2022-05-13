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
    
    func test天気予報がsunnyだったら画面に晴れ画像が表示されること() throws {
        let sunnyWeather = Weather(maxTemp: 10, minTemp: 0, weather: "sunny")
        setupWeatherDisplay(weather: sunnyWeather)
        let image = weatherDisplayViewController.weatherImageView!.image
        XCTAssertEqual(image, UIImage(named: "sunny"))
    }
    
    func test天気予報がcloudyだったら画面に曇り画像が表示されること() throws {
        let cloudyWeather = Weather(maxTemp: 10, minTemp: 0, weather: "cloudy")
        setupWeatherDisplay(weather: cloudyWeather)
        let image = weatherDisplayViewController.weatherImageView!.image
        XCTAssertEqual(image, UIImage(named: "cloudy"))
    }
    
    func test天気予報がrainyだったら画面に雨画像が表示されること() throws {
        let rainyWeather = Weather(maxTemp: 10, minTemp: 0, weather: "rainy")
        setupWeatherDisplay(weather: rainyWeather)
        let image = weatherDisplayViewController.weatherImageView!.image
        XCTAssertEqual(image, UIImage(named: "rainy"))
    }
    
    func test天気予報の最高気温がUILabelに反映されること() throws {
        let weather = Weather(maxTemp: 10, minTemp: 0, weather: "sunny")
        setupWeatherDisplay(weather: weather)
        let maxTempText = weatherDisplayViewController.maxTemperatureLabel.text
        XCTAssertEqual(maxTempText, "10")
    }
    
    func test天気予報の最低気温がUILabelに反映されること() throws {
        let weather = Weather(maxTemp: 10, minTemp: 0, weather: "sunny")
        setupWeatherDisplay(weather: weather)
        let minTempText = weatherDisplayViewController.minTemperatureLabel.text
        XCTAssertEqual(minTempText, "0")
    }
    
    private func setupWeatherDisplay(weather: Weather) {
        let weatherUseCaseStub = WeatherUseCaseStub(weather: weather)
        weatherDisplayViewController = WeatherDisplayViewController.instantiate(
            weatherUseCase: weatherUseCaseStub
        )
        weatherUseCaseStub.delegate = weatherDisplayViewController
        weatherDisplayViewController.loadViewIfNeeded()
        waitForAppearExecuted()
    }
    
    private func waitForAppearExecuted() {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        windowScene?.windows.first?.rootViewController = weatherDisplayViewController
        let expection = expectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            expection.fulfill()
        }
        wait(for: [expection], timeout: 3)
    }
    
}
