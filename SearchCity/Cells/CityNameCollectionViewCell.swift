//
//  CityNameCollectionViewCell.swift
//  SearchCity
//
//  Created by Manish Tamta on 30/05/2022.
//

import UIKit

class CityNameCollectionViewCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}


extension CityNameCollectionViewCell {
    
    static var cityNameCollectionSectionLayout:  NSCollectionLayoutSection {
        let heightDimension = NSCollectionLayoutDimension.absolute(80)

        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: heightDimension)
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets.bottom = 15

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: heightDimension)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets.leading = 15
        group.contentInsets.trailing = 15

        let section = NSCollectionLayoutSection(group: group)
        return section
    }
}
