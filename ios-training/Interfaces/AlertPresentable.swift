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
        actionHandler: ((UIAlertAction) -> Void)?,
        getAlertHandler: ((UIAlertController) -> Void)?
    )
}

extension AlertPresentable where Self: UIViewController {
    
    func presentErrorAlert(
        title: String,
        actionHandler: ((UIAlertAction) -> Void)? = nil,
        getAlertHandler: ((UIAlertController) -> Void)?
    ) {
        let alert = UIAlertController(title: title,
                                      message: nil,
                                      preferredStyle: .alert)
        getAlertHandler?(alert)
        let alertAction = UIAlertAction(title: "閉じる",
                                        style: .default,
                                        handler: actionHandler)
        alert.addAction(alertAction)
        present(alert, animated: true)
    }
    
}
