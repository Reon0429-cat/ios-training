//
//  WeatherDisplayViewController.swift
//  ios-training
//
//  Created by 大西 玲音 on 2022/04/22.
//

import UIKit

final class WeatherDisplayViewController: UIViewController {
    
    @IBOutlet private weak var minTemperatureLabel: UILabel!
    @IBOutlet private weak var maxTemperatureLabel: UILabel!
    @IBOutlet private weak var weatherImageView: UIImageView!
    @IBOutlet private weak var weatherReloadButton: UIButton!
    @IBOutlet private weak var closeButton: UIButton!
    
    private var weatherUseCase: WeatherUseCaseProtocol!
    private var alertController: UIAlertController?
    
    deinit {
        print("debug", #function)
    }
    private var weather: Weather!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherImageView.image = nil
        addObserverWillEnterForegroundNotification()
        displayWeather()
    }
    
    @IBAction private func weatherReloadButtonDidTapped(_ sender: Any) {
        displayWeather()
    }
    
    @IBAction private func closeButtonDidTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @objc private func displayWeather() {
        weatherImageView.image = UIImage(named: weather.imageName)
        weatherImageView.tintColor = weather.imageColor
        minTemperatureLabel.text = String(weather.minTemp)
        maxTemperatureLabel.text = String(weather.maxTemp)
    }
    
    static func instantiate(weather: Weather) -> WeatherDisplayViewController {
        let weatherDisplayStoryboard = UIStoryboard(name: "WeatherDisplay", bundle: nil)
        let viewController = weatherDisplayStoryboard.instantiateViewController(
            withIdentifier: String(describing: WeatherDisplayViewController.self)
        ) as! WeatherDisplayViewController
        viewController.weather = weather
        return viewController
    }
    
    private func addObserverWillEnterForegroundNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(displayWeather),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
    }
    
    private func removeObserverWillEnterForegroundNotification() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
    }
    
}

private extension Weather {
    
    var weatherType: WeatherType {
        guard let weatherType = WeatherType(rawValue: weather) else {
            fatalError("想定外の天気")
        }
        return weatherType
    }
    
    var imageName: String {
        switch weatherType {
        case .sunny:
            return "sunny"
        case .rainy:
            return "rainy"
        case .cloudy:
            return "cloudy"
        }
    }
    
    var imageColor: UIColor {
        switch weatherType {
        case .sunny:
            return .red
        case .rainy:
            return .blue
        case .cloudy:
            return .gray
        }
    }
    
}
