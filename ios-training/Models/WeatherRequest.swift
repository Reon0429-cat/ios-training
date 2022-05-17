//
//  WeatherRequest.swift
//  ios-training
//
//  Created by 大西 玲音 on 2022/04/27.
//

import Foundation

struct WeatherRequest: Encodable {
    let areas: [String]
    let date: Date
}
