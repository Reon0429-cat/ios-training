//
//  NSObjectProtocol+Extension.swift
//  ios-training
//
//  Created by 大西 玲音 on 2022/05/17.
//

import Foundation

extension NSObjectProtocol {

    static var className: String {
        return String(describing: self)
    }

}
