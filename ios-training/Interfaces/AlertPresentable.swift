//
//  AlertPresentable.swift
//  ios-training
//
//  Created by 大西 玲音 on 2022/04/26.
//

import UIKit

protocol AlertPresentable {
    func presentErrorAlert(
        title: String,
        actionHandler: ((UIAlertAction) -> Void)?
    ) -> UIAlertController
}

extension AlertPresentable where Self: UIViewController {
    
    @discardableResult
    func presentErrorAlert(
        title: String,
        actionHandler: ((UIAlertAction) -> Void)? = nil
    ) -> UIAlertController {
        let alert = UIAlertController(title: title,
                                      message: nil,
                                      preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "閉じる",
                                        style: .default,
                                        handler: actionHandler)
        alert.addAction(alertAction)
        present(alert, animated: true)
        return alert
    }
    
}
