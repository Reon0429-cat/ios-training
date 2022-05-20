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
    @IBOutlet private weak var indicatorView: UIActivityIndicatorView!
    
    private var alertController: UIAlertController?
    private var weather: Weather!
    private var weatherUseCase: WeatherUseCaseProtocol!
    
    deinit {
        print("debug", #function)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherImageView.image = nil
        addObserverWillEnterForegroundNotification()
        setupUI(weather: weather)
    }
    
    @IBAction private func weatherReloadButtonDidTapped(_ sender: Any) {
        reloadWeather()
    }
    
    @IBAction private func closeButtonDidTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @objc private func reloadWeather() {
        indicatorView.startAnimating()
        Task {
            do {
                let weatherItems = try await weatherUseCase.fetchWeatherItems()
                guard let weather = weatherItems.map({ $0.info }).randomElement() else {
                    presentErrorAlert(title: "エラーが発生しました。")
                    return
                }
                DispatchQueue.executeMainThread {
                    self.setupUI(weather: weather)
                }
            } catch let error as WeatherFetchError {
                let errorDescription = error.errorDescription ?? ""
                presentErrorAlert(title: "エラーが発生しました。\(errorDescription)")

            } catch {
                presentErrorAlert(title: "予期しないエラーが発生しました。")
            }
        }
    }
    
    private func presentErrorAlert(title: String) {
        removeObserverWillEnterForegroundNotification()
        self.alertController = presentErrorAlert(
            title: title,
            actionHandler: { _ in
                self.addObserverWillEnterForegroundNotification()
            }
        )
        indicatorView.stopAnimating()
    }
    
    private func addObserverWillEnterForegroundNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reloadWeather),
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
    
    private func setupUI(weather: Weather) {
        weatherImageView.image = UIImage(named: weather.imageName)
        weatherImageView.tintColor = weather.imageColor
        minTemperatureLabel.text = String(weather.minTemp)
        maxTemperatureLabel.text = String(weather.maxTemp)
        indicatorView.stopAnimating()
    }
    
    static func instantiate(
        weather: Weather,
        weatherUseCase: WeatherUseCaseProtocol
    ) -> WeatherDisplayViewController {
        let weatherDisplayStoryboard = UIStoryboard(name: "WeatherDisplay", bundle: nil)
        let viewController = weatherDisplayStoryboard.instantiateViewController(
            withIdentifier: String(describing: WeatherDisplayViewController.self)
        ) as! WeatherDisplayViewController
        viewController.weather = weather
        viewController.weatherUseCase = weatherUseCase
        return viewController
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
