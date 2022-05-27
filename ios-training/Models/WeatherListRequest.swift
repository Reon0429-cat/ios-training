//
//  WeatherListRequest.swift
//  ios-training
//
//  Created by 大西 玲音 on 2022/04/27.
//

import Foundation

struct WeatherListRequest: Encodable {
    let areas: [String]
    let date: Date
}
