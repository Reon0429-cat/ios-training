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
    private var weatherItem: WeatherItem!
    private var weatherUseCase: WeatherUseCaseProtocol!
    
    deinit {
        print("debug", #function)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherImageView.image = nil
        addObserverWillEnterForegroundNotification()
        configureUI(weather: weatherItem.info)
    }
    
    @IBAction private func weatherReloadButtonDidTapped(_ sender: Any) {
        reloadWeather()
    }
    
    @IBAction private func closeButtonDidTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @objc private func reloadWeather() {
        indicatorView.startAnimating()
        alertController?.dismiss(animated: true)
        Task {
            do {
                let weather = try await weatherUseCase.fetchWeather(at: weatherItem.area)
                configureUI(weather: weather)
            } catch let error as WeatherFetchError {
                let errorDescription = error.errorDescription ?? ""
                alertController = presentErrorAlert(
                    title: "エラーが発生しました。\(errorDescription)"
                )
                indicatorView.stopAnimating()
            } catch {
                alertController = presentErrorAlert(
                    title: "予期しないエラーが発生しました。"
                )
                indicatorView.stopAnimating()
            }
        }
    }
    
    private func addObserverWillEnterForegroundNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reloadWeather),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
    }
    
    private func configureUI(weather: Weather) {
        weatherImageView.image = UIImage(named: weather.imageName)
        weatherImageView.tintColor = weather.imageColor
        minTemperatureLabel.text = String(weather.minTemp)
        maxTemperatureLabel.text = String(weather.maxTemp)
        indicatorView.stopAnimating()
    }
    
    static func instantiate(
        weatherItem: WeatherItem,
        weatherUseCase: WeatherUseCaseProtocol
    ) -> WeatherDisplayViewController {
        let weatherDisplayStoryboard = UIStoryboard(name: "WeatherDisplay", bundle: nil)
        let viewController = weatherDisplayStoryboard.instantiateViewController(
            withIdentifier: String(describing: WeatherDisplayViewController.self)
        ) as! WeatherDisplayViewController
        viewController.weatherItem = weatherItem
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
