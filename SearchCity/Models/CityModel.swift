//
//  CityModel.swift
//  SearchCity
//
//  Created by Manish Tamta on 30/05/2022.
//

import Foundation

// MARK: - CityModel

typealias CitiesModel = [CityModel]

struct CityModel: Codable {
    let country: String?
    let name: String?
    let id: Int
    let coord: Coord?
    
    var cityNameWithID: String {
        return (name ?? "") + "_\(id)"
    }
    
    enum CodingKeys: String, CodingKey {
        case country, name
        case id = "_id"
        case coord
    }
}

// MARK: - Coord
struct Coord: Codable {
    let lon, lat: Double
}
