//
//  WeatherRequest.swift
//  ios-training
//
//  Created by 大西 玲音 on 2022/05/27.
//

import Foundation

struct WeatherRequest: Encodable {
    let area: String
    let date: Date
}
