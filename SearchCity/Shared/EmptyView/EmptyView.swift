//
//  EmptyView.swift
//  SearchCity
//
//  Created by Manish Tamta on 31/05/2022.
//

import UIKit
import Combine

class EmptyView: NibView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var errorImageView: UIImageView!
    
    
    func setUpData(emptyScreenTitle: String,
                   image: UIImage?) {
        titleLabel.text = emptyScreenTitle
        errorImageView.image = image
        errorImageView.isHidden = (image == nil)
    }
}
