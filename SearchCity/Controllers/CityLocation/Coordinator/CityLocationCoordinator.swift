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
    
    func makeModule() -> UIViewController {
        let vc = createViewController()
        rootController = vc
        return vc
    }
    
    private func createViewController() -> CityLocationViewController {
        let view = CityLocationViewController.instantiateFromStoryboard()
        let viewModel = CityLocationViewModel()
        view.viewModel = viewModel
        return view
    }
}
