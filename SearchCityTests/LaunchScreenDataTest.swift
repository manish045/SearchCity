//
//  CitiesDataTest.swift
//  SearchCityTests
//
//  Created by Manish Tamta on 31/05/2022.
//

import XCTest
@testable import SearchCity

class LaunchScreenDataTest: XCTestCase {
    
    var citiesData: CitiesModel!
    var autocomplete: AutoComplete!

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
    }
    
    override func tearDown() {
        autocomplete = nil
        citiesData = nil
    }
    
    func testParseCitiesData() throws {
        let cityModel = citiesData[0]
        
        XCTAssertEqual("UA", cityModel.country)
        XCTAssertEqual("Hurzuf", cityModel.name)
        XCTAssertEqual(707860, cityModel.id)
        XCTAssertEqual("Hurzuf, UA", cityModel.displayName)
        XCTAssertEqual("Hurzuf_707860", cityModel.cityNameWithID)
        XCTAssertEqual(44.549999, cityModel.coord?.lat)
        XCTAssertEqual(34.283333, cityModel.coord?.lon)
    }
}
