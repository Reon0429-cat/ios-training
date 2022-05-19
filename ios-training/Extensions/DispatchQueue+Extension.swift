//
//  DispatchQueue+Extension.swift
//  ios-training
//
//  Created by 大西 玲音 on 2022/05/12.
//

import Foundation

extension DispatchQueue {

    static func executeMainThread(handler: @escaping () -> Void) {
        if Thread.isMainThread {
            handler()
        } else {
            DispatchQueue.main.async {
                handler()
            }
        }
    }
    
}
