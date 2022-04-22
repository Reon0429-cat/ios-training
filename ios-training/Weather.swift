//
//  Weather.swift
//  ios-training
//
//  Created by 大西 玲音 on 2022/04/22.
//

import UIKit

protocol WeatherProtocol {
    var imageName: String { get }
    var name: String { get }
    var color: UIColor { get }
}

struct Sunny: WeatherProtocol {
    let imageName: String = "sunny"
    let name: String = "sunny"
    let color: UIColor = .red
}

struct Rainy: WeatherProtocol {
    let imageName: String = "rainy"
    let name: String = "rainy"
    let color: UIColor = .blue
}

struct Cloudy: WeatherProtocol {
    let imageName: String = "cloudy"
    let name: String = "cloudy"
    let color: UIColor = .gray
}
