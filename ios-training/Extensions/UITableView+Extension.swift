//
//  UITableView+Extension.swift
//  ios-training
//
//  Created by 大西 玲音 on 2022/05/17.
//

import UIKit

extension UITableView {
    
    func registerCustomCell<T: UITableViewCell>(_ cellType: T.Type) {
        register(
            UINib(nibName: T.identifier, bundle: nil),
            forCellReuseIdentifier: T.identifier
        )
    }
    
    func dequeueReusableCustomCell<T: UITableViewCell>(with cellType: T.Type) -> T {
        return dequeueReusableCell(withIdentifier: T.identifier) as! T
    }
    
}
