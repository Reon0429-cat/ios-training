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
    
    private let weatherPresenter: WeatherPresenterable = WeatherPresenter(
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
        weatherImageView.image = UIImage(named: weather.imageName)
        weatherImageView.tintColor = weather.color
    }
    
}

