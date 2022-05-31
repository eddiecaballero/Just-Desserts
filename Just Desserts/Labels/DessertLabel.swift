//
//  DessertLabel.swift
//  Just Desserts
//
//  Created by Eddie Caballero on 5/30/22.
//

import UIKit

class DessertLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        textColor = .systemPink
        textAlignment = .center
        font = UIFont.systemFont(ofSize: 16, weight: .bold)
        lineBreakMode = .byTruncatingTail
        numberOfLines = 0
        translatesAutoresizingMaskIntoConstraints = false
    }
}
