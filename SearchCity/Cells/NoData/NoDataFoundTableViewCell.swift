//
//  NoDataFoundTableViewCell.swift
//  SearchCity
//
//  Created by Manish Tamta on 31/05/2022.
//

import UIKit

class NoDataFoundTableViewCell: UITableViewCell {

    @IBOutlet weak var emptyView: EmptyView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        emptyView.setUpData(emptyScreenTitle: LConstant.CitySearchViewController.noDataFound, image: UIImage(systemName: "minus.magnifyingglass"))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
