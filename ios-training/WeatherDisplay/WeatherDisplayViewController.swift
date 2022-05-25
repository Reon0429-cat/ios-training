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
    
    private var weatherUseCase: WeatherUseCaseProtocol!
    
    deinit {
        print("debug", #function)
    }
    
    override func loadView() {
        super.loadView()
        weatherImageView.image = nil
    }
    
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
        indicatorView.startAnimating()
        closeAlertIfNeeded()
        Task {
            do {
                let weather = try await weatherUseCase.fetchWeather()
                DispatchQueue.executeMainThread {
                    self.weatherImageView.image = UIImage(named: weather.imageName)
                    self.weatherImageView.tintColor = weather.imageColor
                    self.minTemperatureLabel.text = String(weather.minTemp)
                    self.maxTemperatureLabel.text = String(weather.maxTemp)
                    self.indicatorView.stopAnimating()
                }
            } catch let error as WeatherFetchError {
                self.removeObserverWillEnterForegroundNotification()
                let errorDescription = error.errorDescription ?? ""
                DispatchQueue.executeMainThread {
                    self.presentErrorAlert(title: "エラーが発生しました。\(errorDescription)") { _ in
                        self.addObserverWillEnterForegroundNotification()
                    }
                    self.indicatorView.stopAnimating()
                }
            } catch {
                self.removeObserverWillEnterForegroundNotification()
                DispatchQueue.executeMainThread {
                    self.presentErrorAlert(title: "予期しないエラーが発生しました。") { _ in
                        self.addObserverWillEnterForegroundNotification()
                    }
                    self.indicatorView.stopAnimating()
                }
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
        NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification,
                                               object: nil,
                                               queue: .main) { [weak self] _ in
            guard let self = self else { return }
            self.displayWeather()
        }
    }
    
    private func removeObserverWillEnterForegroundNotification() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
    }
    
    private func closeAlertIfNeeded() {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        let viewController = window?.rootViewController
        let alert = viewController as? UIAlertController
        if let alert = alert {
            alert.dismiss(animated: true)
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
