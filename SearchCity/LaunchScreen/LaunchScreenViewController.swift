//
//  LaunchScreenViewController.swift
//  SearchCity
//
//  Created by Manish Tamta on 30/05/2022.
//

import UIKit

class LaunchScreenViewController: UIViewController {

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
        
    }
}
