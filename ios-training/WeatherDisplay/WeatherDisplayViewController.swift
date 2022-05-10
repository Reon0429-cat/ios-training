//
//  WeatherDisplayViewController.swift
//  ios-training
//
//  Created by 大西 玲音 on 2022/04/22.
//

import UIKit

final class WeatherDisplayViewController: UIViewController {
    
    @IBOutlet weak var minTemperatureLabel: UILabel!
    @IBOutlet weak var maxTemperatureLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet private weak var weatherReloadButton: UIButton!
    @IBOutlet private weak var closeButton: UIButton!
    
    var weatherUseCase: WeatherUseCaseProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addObserverWillEnterForegroundNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        displayWeather()
    }
    
    @IBAction private func weatherReloadButtonDidTapped(_ sender: Any) {
        displayWeather()
    }
    
    @IBAction private func closeButtonDidTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @objc private func displayWeather() {
        do {
            let weather = try weatherUseCase.fetchWeather()
            weatherImageView.image = UIImage(named: weather.imageName)
            weatherImageView.tintColor = weather.imageColor
            minTemperatureLabel.text = String(weather.minTemp)
            maxTemperatureLabel.text = String(weather.maxTemp)
        } catch let error as WeatherFetchError {
            removeObserverWillEnterForegroundNotification()
            let errorDescription = error.errorDescription ?? ""
            presentErrorAlert(title: "エラーが発生しました。\(errorDescription)") { _ in
                self.addObserverWillEnterForegroundNotification()
            }
        } catch {
            removeObserverWillEnterForegroundNotification()
            presentErrorAlert(title: "予期しないエラーが発生しました。") { _ in
                self.addObserverWillEnterForegroundNotification()
            }
        }
    }
    
    static func instantiate(weatherUseCase: WeatherUseCaseProtocol) -> WeatherDisplayViewController {
        let weatherDisplayStoryboard = UIStoryboard(name: "WeatherDisplay", bundle: nil)
        let viewController = weatherDisplayStoryboard.instantiateViewController(
            withIdentifier: String(describing: WeatherDisplayViewController.self)
        ) as! WeatherDisplayViewController
        viewController.weatherUseCase = weatherUseCase
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
