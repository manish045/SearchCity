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
    func searchCityWithPrefix(prefix: String)
    func showCityCoordinatesOnMap(model: CityModel)
}

protocol CitySearchViewModelOutput {
    var loadDataSource: PassthroughSubject<Void, Never> { get}
    var showLoader: PassthroughSubject<Bool, Never> {get}
    var emptySearchResult: Bool {get}
    var citiesfilteredArray: CitiesModel? {get}
}

protocol DefaultCitySearchViewModel: CitySearchViewModelInput, CitySearchViewModelOutput {}

final class CitySearchViewModel: DefaultCitySearchViewModel {
    
    private var coordinator: CitySearchViewCoordinatorInput
    private var autoComplete: AutoComplete
    private var cityDict: [Int: CityModel]
    private var citiesModel: CitiesModel

    var emptySearchResult: Bool = false
    var loadDataSource = PassthroughSubject<Void, Never>()
    var showLoader = PassthroughSubject<Bool, Never>()
    
    var citiesfilteredArray: CitiesModel? {
        didSet {
            emptySearchResult = (citiesfilteredArray?.count ?? 0 <= 0)
            self.loadDataSource.send()
            self.showLoader.send(false)
        }
    }
    
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
    
    func searchCityWithPrefix(prefix: String) {
        self.showLoader.send(true)
        var filterCityDict = [CityModel]()
        if prefix.isEmpty{
            loadCitiesData()
            return
        }else {
            let city =  self.autoComplete.findWordsWithPrefix(prefix: prefix)
            for nameAndId in city {
                let seperateComponents = nameAndId.components(separatedBy: "_")
                if let idKey = Int(seperateComponents[1]) {
                    filterCityDict.append(cityDict[idKey]!)
                }
            }
        }
        self.sortCityData(cityDict: filterCityDict)
    }
    
    private func sortCityData(cityDict: [CityModel]) {
        self.citiesfilteredArray = cityDict.sorted{$0.cityNameWithID < $1.cityNameWithID}
    }
    
    func showCityCoordinatesOnMap(model: CityModel) {
        guard let coord = model.coord, let lat = coord.lat, let lon = coord.lon else {return}
        let mapModel = CityMapModel(lat: lat, long: lon, name: model.displayName)
        self.coordinator.showCityCoordinatesOnMap(model: mapModel)
    }
    
}
