//
//  ListViewModel.swift
//  Just Desserts
//
//  Created by Eddie Caballero on 7/6/22.
//

import Foundation

class ListViewModel {
    
    let service: DessertServiceProtocol!
    var desserts: [Dessert] = []
    
    init(service: DessertServiceProtocol) {
        self.service = service
    }
    
    var onUpdate: ((_ desserts: [Dessert]?) -> Void)?
    
    private func update(desserts: [Dessert]) {
        self.desserts = desserts
        
        self.onUpdate?(desserts)
    }
    
    func getDesserts() {
        service.getDesserts { result in
            switch result {
            case .success(let desserts): self.update(desserts: desserts)
            case .failure(let error): print(error.rawValue)
            }
        }
    }
}
