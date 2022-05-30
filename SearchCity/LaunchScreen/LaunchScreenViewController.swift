//
//  LaunchScreenViewController.swift
//  SearchCity
//
//  Created by Manish Tamta on 30/05/2022.
//

import UIKit

class LaunchScreenViewController: UIViewController {

    var coordinator: CitySearchViewCoordinator?
    let group = DispatchGroup()

    
    override func viewDidLoad() {
        self.parseCitiesViaJSONFile()
    }
    
    private func parseCitiesViaJSONFile() {
        let queue = DispatchQueue(label: "Concurrent_Queue", attributes: .concurrent)
        
        /// Load json file from path
        guard let pathString = Bundle(for: type(of: self)).path(forResource: "cities", ofType: "json") else {
            fatalError("JSON not found")
        }
        
        guard let json = try? String(contentsOfFile: pathString, encoding: .utf8) else {
            fatalError("Unable to convert json")
        }
        
        /// Get data from file
        let jsonData = json.data(using: .utf8)!
        
        /// Decode data to a Array[CitiesModel] object
        let citiesModel = try! JSONDecoder().decode(CitiesModel.self, from: jsonData)
        
        ///Using a tree data structure locating specific keys from within a set.
        let autocomplete = AutoComplete()
        
        /// serailize all Model data into dictionary to get the best complexity for searching Model
        var cityDict = [Int: CityModel]()
        var citiesModelArray = CitiesModel()
        
        /// With dispatch groups we can group together multiple tasks and notified once they are complete
        group.enter()
        queue.async {
            cityDict = self.loadAllDataToDictionary(citiesData: citiesModel)
            citiesModelArray = cityDict.values.sorted {$0.cityNameWithID < $1.cityNameWithID}
            self.group.leave()
        }
        
        group.enter()
        queue.async {
            for cityModel in citiesModel {
                ///Adding id to city will help to find model from dictionary on search
                self.parseDataForAutoCompleteCities(cityName: cityModel.cityNameWithID, autoComplete: autocomplete)
            }
            self.group.leave()
        }
        
        group.notify(queue: queue) {
            /// setting up root view controller
            DispatchQueue.main.async {
                self.createRootViewController()
            }
        }
    }
    
    private func createRootViewController() {
        
        //Following MVVM-C Architechture
        /// 1. Capture the scene
        guard let window = UIApplication.shared.windows.first else { return }
                
        /// 2. Create a view hierarchy programmatically
        let viewController = initalizeViewController()
        let navigation = UINavigationController(rootViewController: viewController)
        
        /// 3. Set the root view controller of the window with your view controller
        window.rootViewController = navigation
        coordinator?.start(from: viewController)
        
        /// 4. Set the window and call makeKeyAndVisible()
        window.makeKeyAndVisible()
        
    }
    
    private func initalizeViewController() -> UIViewController {
        coordinator = CitySearchViewCoordinator()
        return (coordinator?.makeModule())!
    }
    
    private func parseDataForAutoCompleteCities(cityName: String, autoComplete: AutoComplete) {
        ///inserting city to trie structure
        autoComplete.insert(word: cityName)
    }
    
    private func parseDataForAutoCompleteCountries(countryName: String, autoComplete: AutoComplete) {
        ///inserting city to trie structure
        autoComplete.insert(word: countryName)
    }
    
    private func loadAllDataToDictionary(citiesData: CitiesModel) -> [Int: CityModel] {
        var cityDict = [Int: CityModel]()
        for cityModel in citiesData {
            cityDict[cityModel.id] = cityModel
        }
        return cityDict
    }
}
