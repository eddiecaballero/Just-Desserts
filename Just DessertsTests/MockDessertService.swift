//
//  MockDessertService.swift
//  Just DessertsTests
//
//  Created by Eddie Caballero on 7/20/22.
//

import UIKit
@testable import Just_Desserts

class MockDessertService: DessertServiceProtocol {
    func getDesserts(completion: @escaping (Result<[Dessert], AngryError>) -> Void) {}
    
    func getDessert(id: String, completion: @escaping (Result<Dessert, AngryError>) -> Void) {
        guard let url = Bundle(for: MockDessertService.self).url(forResource: "MockDessert", withExtension: "json"),
              let data = try? Data(contentsOf: url) else { return completion(.failure(.dataError)) }
        guard let payload = try? JSONDecoder().decode(Payload.self, from: data)  else {
            completion(.failure(.decodeError))
            return
        }
        guard let dessert = payload.meals?.first else {
            completion(.failure(.noMealsError))
            return
        }
        completion(.success(dessert))
    }
    
    func getImage(from urlString: String, completion: @escaping (UIImage) -> Void) {}
}
