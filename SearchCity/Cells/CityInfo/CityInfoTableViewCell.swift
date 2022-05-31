//
//  CityInfoTableViewCell.swift
//  SearchCity
//
//  Created by Manish Tamta on 31/05/2022.
//

import UIKit

class CityInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var countryNameWithCityLabel: UILabel!
    @IBOutlet weak var locationCoordinatesLabel: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var cityModel: CityModel! {
        didSet {
            countryNameWithCityLabel.text = cityModel.displayName
            locationCoordinatesLabel.text = cityModel.displayCoordinates
        }
    }
    
}
