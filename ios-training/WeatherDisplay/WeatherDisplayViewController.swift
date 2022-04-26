//
//  WeatherDisplayViewController.swift
//  ios-training
//
//  Created by 大西 玲音 on 2022/04/22.
//

import UIKit

final class WeatherDisplayViewController: UIViewController {

    @IBOutlet private weak var weatherImageView: UIImageView!
    @IBOutlet private weak var weatherReloadButton: UIButton!
    
    private let weatherPresenter: WeatherUseCaseProtocol = WeatherUseCase()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        displayWeather()
    }
    
    @IBAction private func weatherReloadButtonDidTapped(_ sender: Any) {
        displayWeather()
    }
    
    private func displayWeather() {
        guard let weather = weatherPresenter.fetchWeather() else {
            fatalError("天気の取得に失敗")
        }
        weatherImageView.image = UIImage(named: weather.imageName)
        weatherImageView.tintColor = weather.imageColor
    }
    
}

private extension WeatherType {
    var imageName: String {
        switch self {
        case .sunny:
            return "sunny"
        case .rainy:
            return "rainy"
        case .cloudy:
            return "cloudy"
        }
    }
    var imageColor: UIColor {
        switch self {
        case .sunny:
            return .red
        case .rainy:
            return .blue
        case .cloudy:
            return .gray
        }
    }
}
