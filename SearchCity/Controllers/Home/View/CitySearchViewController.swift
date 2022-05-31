//
//  CitySearchViewController.swift
//  AutoComplete
//
//  Created by Manish Tamta on 30/05/2022.
//

import UIKit
import Combine

class CitySearchViewController: UIViewController {
    
    enum Section: Int, CaseIterable {
        // This section shows the activity indicator untill all the data is fetched from server
        case loader

        // Shows the number of rows equal to the data fetched from server
        case citiesData
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    private var searchBar = UISearchBar()
    let scheduler: SchedulerContext = SchedulerContextProvider.provide()
    var viewModel: CitySearchViewModel!
    private var showLoader = true
    private var disposeBag = Set<AnyCancellable>()

    override func viewDidLoad() {
        title = "Search Cities"
        self.addObservables()
        super.viewDidLoad()
        configureTableView()
        configureSearchBar()
        self.viewModel.loadCitiesData()
        self.setupSearchBarListeners()
        // Do any additional setup after loading the view.
    }
    
    private func configureTableView() {
        tableView.registerNibCell(ofType: CityInfoTableViewCell.self)
        tableView.registerNibCell(ofType: LoaderTableViewCell.self)
        tableView.dataSource = self
    }
    
    private func configureSearchBar() {
        searchBar.placeholder = "Search..."
        searchBar.sizeToFit()
        
        // the UIViewController comes with a navigationItem property
        // this will automatically be initialized for you if when the
        // view controller is added to a navigation controller's stack
        // you just need to set the titleView to be the search bar
        navigationItem.titleView = searchBar
    }
    
    // observing characters changein searchbar
    private func setupSearchBarListeners() {
        let publisher = NotificationCenter.default.publisher(for: UISearchTextField.textDidChangeNotification, object: self.searchBar.searchTextField)
        publisher.map {
            ($0.object as! UITextField).text ?? ""
        }
        .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
        .removeDuplicates()
        .sink { [weak self] searchText in
            self?.viewModel.searchCityWithPrefix(prefix: searchText)
        }
        .store(in: &disposeBag)
    }
    
    private func addObservables() {
        viewModel.loadDataSource
            .receive(on: scheduler.ui)
            .sink(receiveValue: { [weak self] in
                guard let self = self else {return}
                self.tableView.reloadData()
            }).store(in: &disposeBag)
        
        viewModel.showLoader
            .receive(on: scheduler.ui)
            .sink { [weak self] show in
                guard let self = self else {return}
                self.showLoader = show
                self.tableView.reloadData()
            }
            .store(in: &disposeBag)
    }
}

extension CitySearchViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch Section(rawValue: section) {
        case .citiesData:
            return self.viewModel.citiesfilteredArray?.count ?? 0
        default:
            return showLoader ? 1: 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch Section(rawValue: indexPath.section) {
        case .citiesData:
            let cell = tableView.dequeueCell(ofType: CityInfoTableViewCell.self)
            let cityModel = self.viewModel.citiesfilteredArray?[indexPath.row]
            cell.cityModel = cityModel
            return cell
        default:
            let cell = tableView.dequeueCell(ofType: LoaderTableViewCell.self)
            cell.animateIndicator(show: self.showLoader)
            return cell
        }
    }
}
