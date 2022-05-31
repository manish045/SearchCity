//
//  TrieTest.swift
//  SearchCityTests
//
//  Created by Manish Tamta on 01/06/2022.
//

import XCTest
@testable import SearchCity

class TrieTest: XCTestCase {
    
    var citiesData: CitiesModel!
    var trie: AutoComplete!
    
    override func setUp() {
        super.setUp()
        
        guard let pathString = Bundle(for: type(of: self)).path(forResource: "citiesSample", ofType: "json") else {
            fatalError("json not found")
        }
        
        guard let json = try? String(contentsOfFile: pathString, encoding: .utf8) else {
            fatalError("unable to convert json into string")
        }
        
        let jsonData = json.data(using: .utf8)!
        citiesData = try! JSONDecoder().decode(CitiesModel.self, from: jsonData)
        
        trie = AutoComplete()
        insertWordsIntoTrie()
        
    }
    
    /// load cities from sample json and it shouldn't be nil
    func testCitiesData() {
        XCTAssertNotNil(citiesData)
        XCTAssertEqual(citiesData.count, 7)
    }
    
    /// Inserts words into a trie.  If the trie is non-empty, don't do anything.
    func insertWordsIntoTrie() {
        guard let citiesData = citiesData, trie.count == 0 else { return }
        for word in citiesData {
            trie.insert(word: word.cityNameWithID)
        }
    }
    
    /// Tests that a newly created trie has zero words.
    func testCreate() {
        let trie = AutoComplete()
        XCTAssertEqual(trie.count, 0)
    }
    
    /// Tests the insert method
    func testInsert() {
        let trie = AutoComplete()
        trie.insert(word: "Holubynka")
        trie.insert(word: "Republic of India")
        
        XCTAssertTrue(trie.contains(word: "Holubynka"))
        XCTAssertFalse(trie.contains(word: "Mar’ina Roshcha"))
        
        trie.insert(word: "Hurzuf")
        XCTAssertTrue(trie.contains(word: "Hurzuf"))
        XCTAssertEqual(trie.count, 3)
    }
    
    /// Tests whether word prefixes are properly found and returned.
    func testFindWordsWithPrefix() {
        
        let wordsAll = trie.findWordsWithPrefix(prefix: "")
        XCTAssertEqual(wordsAll.sorted(), ["gorkhā_1283378", "holubynka_708546", "hurzuf_707860", "laspi_703363", "mar’ina roshcha_529334", "republic of india_1269750", "state of haryāna_1270260"])
        
        let cityName = trie.findWordsWithPrefix(prefix: "mar")
        XCTAssertEqual(cityName, ["mar’ina roshcha_529334"])
        
        let noWords = trie.findWordsWithPrefix(prefix: "Aus")
        XCTAssertEqual(noWords, [])
        
        let wordsUpperCase = trie.findWordsWithPrefix(prefix: "H")
        XCTAssertEqual(wordsUpperCase.sorted(), ["holubynka_708546", "hurzuf_707860"])
    }
    
    override func tearDown() {
        citiesData = nil
        trie = nil
    }
}
