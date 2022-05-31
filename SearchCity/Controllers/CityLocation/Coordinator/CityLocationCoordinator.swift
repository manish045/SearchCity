//
//  CityLocationCoordinator.swift
//  SearchCity
//
//  Created by Manish Tamta on 31/05/2022.
//

import UIKit

protocol CityLocationOutputCoordinator {}

class CityLocationCoordinator: Coordinator {
    var rootController: UIViewController?
    
    func makeModule(cityMapModel: CityMapModel) -> UIViewController {
        let vc = createViewController(cityMapModel: cityMapModel)
        rootController = vc
        return vc
    }
    
    private func createViewController(cityMapModel: CityMapModel) -> CityLocationViewController {
        let view = CityLocationViewController.instantiateFromStoryboard()
        let viewModel = CityLocationViewModel(cityMapModel: cityMapModel)
        view.viewModel = viewModel
        return view
    }
}
