//
//  SectionLayoutProvider.swift
//  AutoComplete
//
//  Created by Manish Tamta on 30/05/2022.
//

import UIKit

public protocol SectionLayoutProvider {
    func layout(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection?    
}
