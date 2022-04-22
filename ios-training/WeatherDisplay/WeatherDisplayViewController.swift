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
    
    private let weatherPresenter: WeatherPresentable = WeatherPresenter(
        weatherUseCase: WeatherUseCase()
    )
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayWeather()
        
    }
    
    @IBAction private func weatherReloadButtonDidTapped(_ sender: Any) {
        displayWeather()
    }
    
    private func displayWeather() {
        guard let weather = weatherPresenter.fetchWeather() else { return }
        weatherImageView.image = weather.imageName
        weatherImageView.tintColor = weather.imageColor
    }
    
}

private extension WeatherType {
    var imageName: UIImage? {
        return UIImage(named: self.name)
        switch self {
        case .sunny:
            return UIImage(named: "sunny")
        case .rainy:
            return UIImage(named: "rainy")
        case .cloudy:
            return UIImage(named: "cloudy")
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
