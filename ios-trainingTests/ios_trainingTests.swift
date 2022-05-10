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
        let weatherUseCaseStub = WeatherUseCaseStub(weather: sunnyWeather)
        weatherDisplayViewController = WeatherDisplayViewController.instantiate(
            weatherUseCase: weatherUseCaseStub
        )
        weatherDisplayViewController.loadViewIfNeeded()
        guard let image = weatherDisplayViewController.weatherImageView?.image else {
            throw TestError.failedGetWeatherImage
        }
        XCTAssertEqual(image, UIImage(named: "sunny"))
    }
    
    func test天気予報がcloudyだったら画面に曇り画像が表示されること() throws {
        let cloudyWeather = Weather(maxTemp: 10, minTemp: 0, weather: "cloudy")
        let weatherUseCaseStub = WeatherUseCaseStub(weather: cloudyWeather)
        weatherDisplayViewController = WeatherDisplayViewController.instantiate(
            weatherUseCase: weatherUseCaseStub
        )
        weatherDisplayViewController.loadViewIfNeeded()
        guard let image = weatherDisplayViewController.weatherImageView?.image else {
            throw TestError.failedGetWeatherImage
        }
        XCTAssertEqual(image, UIImage(named: "cloudy"))
    }
    
    func test天気予報がrainyだったら画面に雨画像が表示されること() throws {
        let rainyWeather = Weather(maxTemp: 10, minTemp: 0, weather: "rainy")
        let weatherUseCaseStub = WeatherUseCaseStub(weather: rainyWeather)
        weatherDisplayViewController = WeatherDisplayViewController.instantiate(
            weatherUseCase: weatherUseCaseStub
        )
        weatherDisplayViewController.loadViewIfNeeded()
        guard let image = weatherDisplayViewController.weatherImageView?.image else {
            throw TestError.failedGetWeatherImage
        }
        XCTAssertEqual(image, UIImage(named: "rainy"))
    }
    
    func test天気予報の最高気温がUILabelに反映されること() throws {
        let weather = Weather(maxTemp: 10, minTemp: 0, weather: "sunny")
        let weatherUseCaseStub = WeatherUseCaseStub(weather: weather)
        weatherDisplayViewController = WeatherDisplayViewController.instantiate(
            weatherUseCase: weatherUseCaseStub
        )
        weatherDisplayViewController.loadViewIfNeeded()
        guard let maxTempText = weatherDisplayViewController.maxTemperatureLabel.text else {
            throw TestError.failedGetMaxWeatherText
        }
        XCTAssertEqual(maxTempText, "10")
    }
    
    func test天気予報の最低気温がUILabelに反映されること() throws {
        let weather = Weather(maxTemp: 10, minTemp: 0, weather: "sunny")
        let weatherUseCaseStub = WeatherUseCaseStub(weather: weather)
        weatherDisplayViewController = WeatherDisplayViewController.instantiate(
            weatherUseCase: weatherUseCaseStub
        )
        weatherDisplayViewController.loadViewIfNeeded()
        guard let minTempText = weatherDisplayViewController.minTemperatureLabel.text else {
            throw TestError.failedGetMinWeatherText
        }
        XCTAssertEqual(minTempText, "0")
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
