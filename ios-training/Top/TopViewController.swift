//
//  TopViewController.swift
//  ios-training
//
//  Created by 大西 玲音 on 2022/04/27.
//

import UIKit

final class TopViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentWeatherDisplay()
    }
    
    private func presentWeatherDisplay() {
        let weatherUseCase = WeatherUseCase()
        let viewController = WeatherDisplayViewController.instantiate(weatherUseCase: weatherUseCase)
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true)
    }
    
}
