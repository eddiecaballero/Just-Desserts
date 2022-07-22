//
//  DessertCellViewModel.swift
//  Just Desserts
//
//  Created by Eddie Caballero on 7/18/22.
//

import UIKit

class DessertCellViewModel {
    let service: DessertServiceProtocol!
    var dessert: Dessert!
    var image: UIImage!
    
    init(service: DessertServiceProtocol, dessert: Dessert, placeholderImage: UIImage) {
        self.service = service
        self.dessert = dessert
        self.image = placeholderImage
    }
    
    var onUpdate: ((_ image: UIImage?) -> Void)?
    
    private func update(image: UIImage) {
        self.onUpdate?(image)
    }
    
    func getImage(fromURL urlString: String) {
        service.getImage(from: urlString) { self.update(image: $0) }
    }
}
