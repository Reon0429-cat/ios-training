//
//  Weather.swift
//  ios-training
//
//  Created by 大西 玲音 on 2022/04/27.
//

import Foundation

actor Weather: Decodable {
    let maxTemp: Int
    let minTemp: Int
    let weather: String
}
