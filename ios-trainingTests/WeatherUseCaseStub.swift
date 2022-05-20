//
//  WeatherUseCaseStub.swift
//  ios-training
//
//  Created by 大西 玲音 on 2022/05/10.
//

import Foundation
@testable import ios_training

final class WeatherUseCaseStub: WeatherUseCaseProtocol {
    
    weak var delegate: WeatherUseCaseDelegate?
    let weather: Weather
    
    init(weather: Weather) {
        self.weather = weather
    }
    
    func fetchWeather() {
        delegate?.didFetchedWeather(weather: weather)
    }

}
