//
//  CitySearchViewCoordinator.swift
//  AutoComplete
//
//  Created by Manish Tamta on 30/05/2022.
//

import UIKit

protocol CitySearchViewCoordinatorInput {
    
}

class CitySearchViewCoordinator: Coordinator, CitySearchViewCoordinatorInput {
    var rootController: UIViewController?
    
    func start(from presentingController: UIViewController) {
        self.rootController = presentingController
    }
    
    //Create View Controller instance with all possible initialization for viewModel and controller
    func makeModule() -> UIViewController {
        let vc = createViewController()
        return vc
    }
    
    private func createViewController() -> CitySearchViewController {
        // initializing view controller
        let view = CitySearchViewController.instantiateFromStoryboard()
        let viewModel = CitySearchViewModel(coordinator: self)
        view.viewModel = viewModel
        return view
    }
}
