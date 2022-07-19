//
//  DetailsViewModel.swift
//  Just Desserts
//
//  Created by Eddie Caballero on 7/6/22.
//

import UIKit

class DetailsViewModel {
    let service: DessertService = DessertService()
    var dessert: Dessert!
    var image: UIImage!
    
    init(dessert: Dessert, image: UIImage) {
        self.dessert = dessert
        self.image = image
    }
    
    var onUpdate: ((_ dessert: Dessert?, _ image: UIImage?) -> Void)?
    
    private func update(dessert: Dessert) {
        self.dessert = dessert
        
        self.onUpdate?(dessert, image)
    }
    
    func getDessert() {
        service.getDessert(id: dessert.idMeal) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let dessert): self.update(dessert: dessert)
            case .failure(let error): print(error.rawValue)
            }
        }
    }
}
