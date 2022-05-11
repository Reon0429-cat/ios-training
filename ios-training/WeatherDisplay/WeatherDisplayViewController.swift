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
    
    private let weatherUseCse: WeatherUseCaseProtocol = WeatherUseCase()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayWeather()
        addObserver(name: UIApplication.willEnterForegroundNotification)
    }
    
    @IBAction private func weatherReloadButtonDidTapped(_ sender: Any) {
        displayWeather()
    }
    
    @IBAction private func closeButtonDidTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @objc private func displayWeather() {
        do {
            let weather = try weatherUseCse.fetchWeather()
            weatherImageView.image = UIImage(named: weather.imageName)
            weatherImageView.tintColor = weather.imageColor
            minTemperatureLabel.text = String(weather.minTemp)
            maxTemperatureLabel.text = String(weather.maxTemp)
        } catch let error as WeatherFetchError {
            removeObserver(name: UIApplication.willEnterForegroundNotification)
            let errorDescription = error.errorDescription ?? ""
            presentErrorAlert(title: "エラーが発生しました。\(errorDescription)") { _ in
                self.addObserver(name: UIApplication.willEnterForegroundNotification)
            }
        } catch {
            removeObserver(name: UIApplication.willEnterForegroundNotification)
            presentErrorAlert(title: "予期しないエラーが発生しました。") { _ in
                self.addObserver(name: UIApplication.willEnterForegroundNotification)
            }
        }
    }
    
    static func instantiate() -> WeatherDisplayViewController {
        let weatherDisplayStoryboard = UIStoryboard(name: "WeatherDisplay", bundle: nil)
        let viewController = weatherDisplayStoryboard.instantiateViewController(
            withIdentifier: String(describing: WeatherDisplayViewController.self)
        ) as! WeatherDisplayViewController
        return viewController
    }
    
    private func addObserver(name: NSNotification.Name?) {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(displayWeather),
            name: name,
            object: nil
        )
    }
    
    private func removeObserver(name: NSNotification.Name?) {
        NotificationCenter.default.removeObserver(
            self,
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
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
