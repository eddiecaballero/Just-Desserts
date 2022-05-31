//
//  CardLabel.swift
//  Just Desserts
//
//  Created by Eddie Caballero on 5/30/22.
//

import UIKit

class CardLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        numberOfLines = 0
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
