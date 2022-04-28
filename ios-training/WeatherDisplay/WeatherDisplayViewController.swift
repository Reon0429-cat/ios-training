//
//  WeatherDisplayViewController.swift
//  ios-training
//
//  Created by 大西 玲音 on 2022/04/22.
//

import UIKit
import YumemiWeather

final class WeatherDisplayViewController: UIViewController {
    
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
        } catch let error as WeatherFetchError {
            presentErrorAlert(title: "エラーが発生しました。\(error.errorText)")
        } catch let error as YumemiWeatherError {
            switch error {
            case .invalidParameterError:
                presentErrorAlert(title: "無効なパラメーターエラーが発生しました。\(error)")
            case .unknownError:
                presentErrorAlert(title: "不明なエラーが発生しました。\(error)")
            }
        } catch {
            presentErrorAlert(title: "予期しないエラーが発生しました。")
        }
    }
    
}

extension WeatherDisplayViewController: AlertPresentable { }

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
