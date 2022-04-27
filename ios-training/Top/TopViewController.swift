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
        presentWeatherDisplayVC()
    }
    
    private func presentWeatherDisplayVC() {
        let weatherDisplayVC = WeatherDisplayViewController.instantiate()
        weatherDisplayVC.modalPresentationStyle = .fullScreen
        present(weatherDisplayVC, animated: true)
    }
    
}
