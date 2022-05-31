//
//  DessertImageView.swift
//  Just Desserts
//
//  Created by Eddie Caballero on 5/30/22.
//

import UIKit

class DessertImageView: UIImageView {

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        //image = DessertImage.placeholder
        layer.cornerRadius = 10
        clipsToBounds = true
        contentMode = .scaleAspectFill
        translatesAutoresizingMaskIntoConstraints = false
    }
}

