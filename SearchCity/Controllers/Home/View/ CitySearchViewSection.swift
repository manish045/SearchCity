//
//   CitySearchViewSection.swift
//  SearchCity
//
//  Created by Manish Tamta on 30/05/2022.
//

import UIKit

enum CityNameSection: Int {
    case cityData = 0
    case loader
}

enum CityItem: Hashable {
    case resultItem(CityModel)
    case loading(LoadingItem)
}

extension CityNameSection: Sectionable {
    func layout(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? {
        switch self {
        case .cityData:
            // Section
            let layoutSection = CityNameCollectionViewCell.cityNameCollectionSectionLayout
            layoutSection.contentInsets.top = 15
            return layoutSection
        case .loader:
            return LoadingCollectionCell.loadingSectionLayout
        }
    }
}
