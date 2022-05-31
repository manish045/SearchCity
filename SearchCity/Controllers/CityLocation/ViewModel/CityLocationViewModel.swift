//
//  CityLocationViewModel.swift
//  SearchCity
//
//  Created by Manish Tamta on 31/05/2022.
//

import MapKit
import Combine

protocol CityLocationInputViewModel {
    func loadMap()
}

protocol CityLocationOutputViewModel {
    var showLocationOnMap: PassthroughSubject<MKPointAnnotation,Never> {get}
    var placeName: String {get}
}

protocol DefaultCityLocationViewModel: CityLocationInputViewModel, CityLocationOutputViewModel {}

final class CityLocationViewModel {
    
    var showLocationOnMap = PassthroughSubject<MKPointAnnotation,Never>()

    private let cityMapModel: CityMapModel
    var placeName: String
    
    init(cityMapModel: CityMapModel) {
        self.cityMapModel = cityMapModel
        self.placeName = cityMapModel.name
    }
    
    func loadMap() {
        let coordinate = CLLocationCoordinate2D(latitude: self.cityMapModel.lat,
                                                longitude: self.cityMapModel.long)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        showLocationOnMap.send(annotation)
    }
}

