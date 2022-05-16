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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addObserverWillEnterForegroundNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {
            await self.displayWeather()
        }
    }
    
    @IBAction private func weatherReloadButtonDidTapped(_ sender: Any) {
        Task {
            await self.displayWeather()
        }
    }
    
    @IBAction private func closeButtonDidTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @objc private func displayWeather() async {
        print("debug", "indicatorView.startAnimating")
        indicatorView.startAnimating()
        do {
            let weather = try await weatherUseCase.fetchWeather()
            DispatchQueue.executeMainThread {
                Task {
                    self.weatherImageView.image = UIImage(named: await weather.imageName)
                    self.weatherImageView.tintColor = await weather.imageColor
                }
                self.minTemperatureLabel.text = String(weather.minTemp)
                self.maxTemperatureLabel.text = String(weather.maxTemp)
                print("debug", "indicatorView.stopAnimating")
                self.indicatorView.stopAnimating()
            }
        } catch let error as WeatherFetchError {
            self.removeObserverWillEnterForegroundNotification()
            let errorDescription = error.errorDescription ?? ""
            DispatchQueue.executeMainThread {
                self.presentErrorAlert(title: "エラーが発生しました。\(errorDescription)") { _ in
                    self.addObserverWillEnterForegroundNotification()
                }
                print("debug", "indicatorView.stopAnimating")
                self.indicatorView.stopAnimating()
            }
        } catch {
            self.removeObserverWillEnterForegroundNotification()
            DispatchQueue.executeMainThread {
                self.presentErrorAlert(title: "予期しないエラーが発生しました。") { _ in
                    self.addObserverWillEnterForegroundNotification()
                }
                print("debug", "indicatorView.stopAnimating")
                self.indicatorView.stopAnimating()
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
