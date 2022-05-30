//
//  CitySearchViewController.swift
//  AutoComplete
//
//  Created by Manish Tamta on 30/05/2022.
//

import UIKit
import Combine

class CitySearchViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel: CitySearchViewModel!
    let scheduler: SchedulerContext = SchedulerContextProvider.provide()
    private var disposeBag = Set<AnyCancellable>()
    
    private lazy var datasource = DiffableDatasource<CityNameSection, CityItem>(collectionView: collectionView!, scheduler: self.scheduler)
    { [unowned self] (collectionView, indexPath, item) -> UICollectionViewCell? in
        switch item {
        case .resultItem(let model):
            let cell = collectionView.dequeueCell(CityNameCollectionViewCell.self, indexPath: indexPath)
            cell.cityModel = model
            return cell
        case .loading(let loadingItem):
            let cell = collectionView.dequeueCell(LoadingCollectionCell.self, indexPath: indexPath)
            cell.configure(data: loadingItem)
            return cell
        }
    } supplementaryViewProvider: {
        [unowned self] (collectionView, kind, indexPath, section) -> UICollectionReusableView? in
        return nil
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        createSnapshot(cityList: [], state: .loading)
        addViewModelObservers()
        viewModel.loadCitiesData()
        // Do any additional setup after loading the view.
    }

    //Register Cells for collectionView
    private func configureCollectionView() {
        collectionView.registerNibCell(ofType: CityNameCollectionViewCell.self)
    }
    
    //MARK :- Create and construct a section snapshot, then apply to `main` section in data source.
    func createSnapshot(cityList: CitiesModel, state: LoadingState) {
        var snapshot = datasource.snapshot()
        snapshot.deleteAllItems()
        
        //Append Section to snapshot
        snapshot.appendSections([.sections(.cityData)])
        
        //Serialize data according to cell model
        let displayingItems: [ItemHolder<CityItem>] = cityList.map{.items(.resultItem($0))}
        
        //Append cell to desired section
        snapshot.appendItems(displayingItems, toSection: .sections(.cityData))
        
        if state == .default || state == .loading{
            snapshot.appendSections([.loading])
            let loadingItem = LoadingItem(state: state)
            snapshot.appendItems([.loading(loadingItem)], toSection: .loading)
        }
        
        //Apply snapshot to datasource to reload data in collectionView
        datasource.apply(snapshot)
    }
    
    private func addViewModelObservers() {
        viewModel.loadDataSource
            .receive(on: scheduler.ui)
            .sink { [weak self]  cityList in
                guard let self = self else {return}
                let state: LoadingState = .completed
                self.createSnapshot(cityList: cityList, state: state)
            }
            .store(in: &disposeBag)
    }
}
