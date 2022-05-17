//
//  WeatherTableViewCell.swift
//  ios-training
//
//  Created by 大西 玲音 on 2022/05/17.
//

import UIKit

final class WeatherTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var weatherIconImageView: UIImageView!
    @IBOutlet private weak var cityNameLabel: UILabel!
    @IBOutlet private weak var minTempLabel: UILabel!
    @IBOutlet private weak var maxTempLabel: UILabel!
    
    func configure(with weather: (weather: Weather, area: String)) {
        weatherIconImageView.image = UIImage(named: weather.weather.imageName)
        weatherIconImageView.tintColor = weather.weather.imageColor
        minTempLabel.text = String(weather.weather.minTemp)
        maxTempLabel.text = String(weather.weather.maxTemp)
        cityNameLabel.text = weather.area
    }
    
}

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

