//
//  CitySearchViewController.swift
//  AutoComplete
//
//  Created by Manish Tamta on 30/05/2022.
//

import UIKit
import Combine

class CitySearchViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private var searchBar = UISearchBar()

    var viewModel: CitySearchViewModel!
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
            .sink(receiveValue: { [weak self] in
            guard let self = self else {return}
            self.tableView.reloadData()
        }).store(in: &disposeBag)
    }
}

extension CitySearchViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.citiesfilteredArray?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(ofType: CityInfoTableViewCell.self)
        let cityModel = self.viewModel.citiesfilteredArray?[indexPath.row]
        cell.cityModel = cityModel
        return cell
    }
}
