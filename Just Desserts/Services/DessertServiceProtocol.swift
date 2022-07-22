//
//  DessertServiceProtocol.swift
//  Just Desserts
//
//  Created by Eddie Caballero on 7/20/22.
//

import UIKit

protocol DessertServiceProtocol {
    func getDesserts(completion: @escaping (Result<[Dessert], AngryError>) -> Void)
    func getDessert(id: String, completion: @escaping (Result<Dessert, AngryError>) -> Void)
    func getImage(from urlString: String, completion: @escaping (UIImage) -> Void)
}
