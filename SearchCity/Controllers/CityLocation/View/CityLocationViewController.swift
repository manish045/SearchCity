//
//  CityLocationViewController.swift
//  SearchCity
//
//  Created by Manish Tamta on 31/05/2022.
//

import UIKit
import Combine
import MapKit

class CityLocationViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    var viewModel: CityLocationViewModel!
    
    private var disposeBag = Set<AnyCancellable>()

    override func viewDidLoad() {
        addObservers()
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = viewModel.placeName
        viewModel.loadMap()
    }
    
    private func addObservers() {
        viewModel.showLocationOnMap
            .sink { [weak self] annotation in
                self?.mapView.showAnnotations([annotation], animated: false)
            }
            .store(in: &self.disposeBag)
    }
}
