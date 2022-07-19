//
//  DessertService.swift
//  Just Desserts
//
//  Created by Eddie Caballero on 7/11/22.
//

import UIKit

class DessertService {

    public func getDesserts(completion: @escaping (Result<[Dessert], AngryError>) -> Void) {
        NetworkManager.shared.call(endpoint: DessertEndpoint.desserts) { (result: Result<Payload, AngryError>) in
            switch result {
            case .success(let payload):
                guard let desserts = payload.meals else {
                    completion(.failure(.noMealsError))
                    return
                }
                let sortedDesserts = desserts.sorted(by: {$0.strMeal > $1.strMeal})
                completion(.success(sortedDesserts))
            case .failure(let error): completion(.failure(error))
            }
        }
    }
    
    func getDessert(id: String, completion: @escaping (Result<Dessert, AngryError>) -> Void) {
        NetworkManager.shared.call(endpoint: DessertEndpoint.dessert(id: id)) { (result: Result<Payload, AngryError>) in
            switch result {
            case .success(let payload):
                guard let dessert = payload.meals?.first else {
                    completion(.failure(.noMealsError))
                    return
                }
                completion(.success(dessert))
            case .failure(let error): completion(.failure(error))
            }
        }
    }
    
    func getImage(from urlString: String, completion: @escaping (UIImage) -> Void) {
        NetworkManager.shared.getImage(from: urlString, placeholderImage: DessertImage.placeholder) { completion($0) }
    }
}
