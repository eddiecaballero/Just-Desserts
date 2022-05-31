//
//  DessertCell.swift
//  Just Desserts
//
//  Created by Eddie Caballero on 5/26/22.
//

import UIKit

class DessertCell: UICollectionViewCell {
    
    static let reuseID = "DessertCell"
    let dessertImageView = DessertImageView()
    let dessertLabel = DessertLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(dessert: Dessert) {
        setImage(fromURL: dessert.strMealThumb)
        dessertLabel.text = dessert.strMeal
    }
    
    private func setupUI() {
        addSubviews(dessertImageView, dessertLabel)
        
        let padding: CGFloat = 8
        
        dessertImageView.translatesAutoresizingMaskIntoConstraints = false
        dessertLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dessertImageView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            dessertImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            dessertImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            dessertImageView.heightAnchor.constraint(equalTo: dessertImageView.widthAnchor),
            
            dessertLabel.topAnchor.constraint(equalTo: dessertImageView.bottomAnchor, constant: padding),
            dessertLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            dessertLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            dessertLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func setImage(fromURL url: String) {
        NetworkManager.shared.getImage(from: url) { [weak self] image in
            guard let self = self else { return }
            DispatchQueue.main.async { self.dessertImageView.image = image }
        }
    }
}

