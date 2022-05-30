//
//  CitySearchViewModel.swift
//  AutoComplete
//
//  Created by Manish Tamta on 30/05/2022.
//

import Foundation

protocol CitySearchViewModelInput {

}

protocol CitySearchViewModelOutput {
    
}

protocol DefaultCitySearchViewModel: CitySearchViewModelInput, CitySearchViewModelOutput {}

final class CitySearchViewModel: DefaultCitySearchViewModel {
    
    var coordinator: CitySearchViewCoordinatorInput
    
    init(coordinator: CitySearchViewCoordinatorInput) {
        self.coordinator = coordinator
    }
}
