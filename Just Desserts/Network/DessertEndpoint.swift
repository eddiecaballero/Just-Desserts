//
//  DessertEndpoint.swift
//  Just Desserts
//
//  Created by Eddie Caballero on 7/13/22.
//

import Foundation

//https://www.themealdb.com/api/json/v1/1/filter.php?c=Dessert
//https://www.themealdb.com/api/json/v1/1/lookup.php?i=\(id)

enum DessertEndpoint: Endpoint {
case desserts
case dessert(id: String)
    
    var scheme: String {
        switch self {
        default: return "https"
        }
    }
    
    var host: String {
        switch self {
        default: return "themealdb.com"
        }
    }
    
    var path: String {
        switch self {
        case .desserts: return path(resource: "filter.php")
        case .dessert: return path(resource: "lookup.php")
        }
    }
    
    var parameters: [URLQueryItem] {
        switch self {
        case .desserts: return [URLQueryItem(name: "c", value: "Dessert")]
        case .dessert(let id): return [URLQueryItem(name: "i", value: id)]
        }
    }
    
    var method: String {
        switch self {
        default: return "GET"
        }
    }
    
    private func path(resource: String) -> String { "/api/json/v1/1/\(resource)" }
}
