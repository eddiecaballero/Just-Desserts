//
//  CardView.swift
//  Just Desserts
//
//  Created by Eddie Caballero on 5/30/22.
//

import UIKit

class CardView: UIView {
    
    let label = CardLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .systemBackground
        cornerRadius = 10
        addShadow(color: .systemGray)
        
        addSubview(label)
        translatesAutoresizingMaskIntoConstraints = false
        let padding: CGFloat = 8
        label.pinToEdges(of: self, padding: padding)
    }
}
