//
//  Weather.swift
//  ios-training
//
//  Created by 大西 玲音 on 2022/04/22.
//

import Foundation
import UIKit

protocol Weatherable {
    var imageName: String { get }
    var name: String { get }
    var color: UIColor { get }
}

struct Sunny: Weatherable {
    let imageName: String = "sunny"
    let name: String = "sunny"
    let color: UIColor = .red
}

struct Rainy: Weatherable {
    let imageName: String = "rainy"
    let name: String = "rainy"
    let color: UIColor = .blue
}

struct Cloudy: Weatherable {
    let imageName: String = "cloudy"
    let name: String = "cloudy"
    let color: UIColor = .gray
}
