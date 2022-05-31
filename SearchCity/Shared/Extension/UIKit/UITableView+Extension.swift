//
//  UITableView+Extension.swift
//  AutoComplete
//
//  Created by Manish Tamta on 30/05/2022.
//

import UIKit
 
public extension UITableView {
    
    func dequeueCell<T: UITableViewCell>(ofType cellType: T.Type) -> T {
        return dequeueReusableCell(withIdentifier: "\(cellType)") as! T
    }
    
    func registerNibCell<T: UITableViewCell>(ofType cellType: T.Type) {
        let nib = UINib(nibName: "\(cellType)", bundle: nil)
        register(nib, forCellReuseIdentifier: "\(cellType)")
    }
}

