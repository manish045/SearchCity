//
//  CitySearchViewModel.swift
//  AutoComplete
//
//  Created by Manish Tamta on 30/05/2022.
//

import Foundation
import Combine

protocol CitySearchViewModelInput {
    func loadCitiesData()
}

protocol CitySearchViewModelOutput {
    var loadDataSource: Published<CitiesModel>.Publisher { get}
}

protocol DefaultCitySearchViewModel: CitySearchViewModelInput, CitySearchViewModelOutput {}

final class CitySearchViewModel: DefaultCitySearchViewModel {
    
    private var coordinator: CitySearchViewCoordinatorInput
    private var autoComplete: AutoComplete
    private var cityDict: [Int: CityModel]
    private var citiesModel: CitiesModel

    @Published private var citiesfilteredArray = CitiesModel()
    var loadDataSource: Published<CitiesModel>.Publisher {$citiesfilteredArray}
    
    
    init(coordinator: CitySearchViewCoordinatorInput,
         autoComplete: AutoComplete,
         cityDict: [Int: CityModel],
         citiesModelArray: CitiesModel) {
        
        self.coordinator = coordinator
        self.autoComplete = autoComplete
        self.cityDict = cityDict
        self.citiesModel = citiesModelArray
    }
    
    func loadCitiesData() {
        self.citiesfilteredArray = self.citiesModel
    }
}
