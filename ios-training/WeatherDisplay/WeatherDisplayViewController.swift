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
    
    private let weatherUseCse: WeatherUseCaseProtocol = WeatherUseCase()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayWeather()
    }
    
    @IBAction private func weatherReloadButtonDidTapped(_ sender: Any) {
        displayWeather()
    }
    
    private func displayWeather() {
        do {
            let weather = try weatherUseCse.fetchWeather()
            weatherImageView.image = UIImage(named: weather.imageName)
            weatherImageView.tintColor = weather.imageColor
            minTemperatureLabel.text = String(weather.minTemp)
            maxTemperatureLabel.text = String(weather.maxTemp)
        } catch let error as WeatherFetchError {
            let errorDescription = error.errorDescription ?? ""
            presentErrorAlert(title: "エラーが発生しました。\(errorDescription)")
        } catch {
            presentErrorAlert(title: "予期しないエラーが発生しました。")
        }
    }
    
}

extension WeatherDisplayViewController: AlertPresentable { }

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
