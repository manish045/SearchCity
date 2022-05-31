//
//  CitySearchTests.swift
//  SearchCityTests
//
//  Created by Manish Tamta on 31/05/2022.
//

import XCTest
import Combine
@testable import SearchCity

class CitySearchTests: XCTestCase {
    
    var citiesData: CitiesModel!
    var autocomplete: AutoComplete!
    var cityDict: [Int: CityModel]!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        guard let pathString = Bundle(for: type(of: self)).path(forResource: "citiesSample", ofType: "json") else {
            fatalError("json not found")
        }
        
        guard let json = try? String(contentsOfFile: pathString, encoding: .utf8) else {
            fatalError("unable to convert json into string")
        }
        
        let jsonData = json.data(using: .utf8)!
        citiesData = try! JSONDecoder().decode(CitiesModel.self, from: jsonData)
        
        autocomplete = AutoComplete()
        cityDict = [Int: CityModel]()
        cancellables = []
        
        XCTAssertNotNil(citiesData)
    }
    
    override func tearDown() {
        autocomplete = nil
        citiesData = nil
        cityDict = nil
        cancellables = nil
    }
    
    //MARK:- Test the datasource loading request from json
    func testEmptyValueInDataSourceWhenLoadingDataFromServer() throws {
        
        let sut = try makeSUT()
        let tableView = sut.tableView
        // expected one section
        XCTAssertEqual(tableView?.numberOfSections, 3, "Expected two section in table view")
        
        XCTAssertEqual(tableView?.numberOfRows(inSection: 0), 1)
        XCTAssertEqual(tableView?.numberOfRows(inSection: 1), 7)
        XCTAssertEqual(tableView?.numberOfRows(inSection: 2), 0)
        
        // expected one cells
  //      XCTAssertEqual(tableView?.numberOfRows(inSection: MarvelCharacterSection.loader.rawValue), 1)
    }
    
    //MARK:- Test the datasource after empty request from json with Zero Data
    func testEmptyValueInDataSourceWhenFailedLoadingWithZerorResultFromServer() throws {
        
        let sut = try makeSUT()
        let tableView = sut.tableView
        
        sut.viewModel.citiesfilteredArray!.removeAll()
        
        XCTAssertEqual(tableView?.numberOfSections, 3, "Expected two section in table view")
        
        
        // expected zero cells from section 1 and show no data found
        XCTAssertEqual(tableView?.numberOfRows(inSection: 0), 1)
        XCTAssertEqual(tableView?.numberOfRows(inSection: 1), 0)
        XCTAssertEqual(tableView?.numberOfRows(inSection: 2), 1)
    }
    
    //MARK:- Test the parsed value for models
    func testParsedDataValue() throws {
    
        let model = citiesData[0]
        
        XCTAssertEqual(model.displayName, "Hurzuf, UA")
        XCTAssertEqual(model.cityNameWithID, "Hurzuf_707860")
        XCTAssertEqual(model.displayCoordinates, "44.549999, 34.283333")
        XCTAssertNotNil(model.id)
    }
    
    //MARK:- Test observers are working as expectation
    func testObservers() throws {
        let sut = try makeSUT()
        
        let viewModel = sut.viewModel!
        
        let expectation = XCTestExpectation(description: "load data")
        let loaderExpectation = XCTestExpectation(description: "Show Loader")
        
        viewModel.loadDataSource
            .receive(on: sut.scheduler.ui)
            .sink (receiveValue: { _ in
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        viewModel.showLoader
            .receive(on: sut.scheduler.ui)
            .sink { show in
                XCTAssertNotNil(show)
                loaderExpectation.fulfill()
            }
            .store(in: &cancellables)
    }
    
    
    /// test search results in viewModel
    func testCitySearch() throws {
        insertWordsIntoTrie()
        
        XCTAssertEqual(cityDict.count, 0)
        cityDict = loadAllDataToDictionary(citiesData: citiesData)
        XCTAssertNotNil(cityDict)
        
        let sut = try makeSUT()
        let viewModel = sut.viewModel!
        
        XCTAssertNotNil(viewModel.citiesfilteredArray)
        XCTAssertEqual(viewModel.citiesfilteredArray?.count, 7)
        
        viewModel.searchCityWithPrefix(prefix: "")
        XCTAssertEqual(viewModel.citiesfilteredArray?.count, 7)
        
        viewModel.searchCityWithPrefix(prefix: "S")
        XCTAssertEqual(viewModel.citiesfilteredArray?.count, 1)
        XCTAssertEqual(viewModel.citiesfilteredArray![0].displayName, "State of Haryāna, IN")
        
        viewModel.searchCityWithPrefix(prefix: "h")
        XCTAssertEqual(viewModel.citiesfilteredArray![0].name, "Holubynka")
        XCTAssertEqual(viewModel.citiesfilteredArray![1].name, "Hurzuf")
    }
    
    /// Inserts words into a trie.  If the trie is non-empty, don't do anything.
    func insertWordsIntoTrie() {
        guard let citiesData = citiesData, autocomplete.count == 0 else { return }
        for word in citiesData {
            autocomplete.insert(word: word.cityNameWithID)
        }
    }
    
    func loadAllDataToDictionary(citiesData: CitiesModel) -> [Int: CityModel] {
        var cityDict = [Int: CityModel]()
        for cityModel in citiesData {
            cityDict[cityModel.id] = cityModel
        }
        return cityDict
    }

    private func makeSUT() throws -> CitySearchViewController  {
        let coordinator = CitySearchViewCoordinator()
        
        let sut = try XCTUnwrap(coordinator.makeModule(autoComplete: autocomplete, cityDict: cityDict, citiesModelArray: citiesData) as? CitySearchViewController)
        let viewModel = CitySearchViewModel(coordinator: coordinator, autoComplete: autocomplete, cityDict: cityDict, citiesModelArray: citiesData)
        sut.viewModel = viewModel
        _ = sut.view
        return sut
    }
}

