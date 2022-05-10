//
//  AlertPresentable.swift
//  ios-training
//
//  Created by 大西 玲音 on 2022/04/26.
//

import UIKit

protocol AlertPresentable {
    func presentErrorAlert(title: String)
}

extension AlertPresentable where Self: UIViewController {
    
    func presentErrorAlert(title: String) {
        let alert = UIAlertController(title: title,
                                      message: nil,
                                      preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "閉じる", style: .default)
        alert.addAction(alertAction)
        present(alert, animated: true)
    }
    
}
