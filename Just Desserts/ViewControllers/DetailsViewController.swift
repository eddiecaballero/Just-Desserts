//
//  DetailsViewController.swift
//  Just Desserts
//
//  Created by Eddie Caballero on 5/25/22.
//

import UIKit

class DetailsViewController: UIViewController {
    
    //MARK: - Properties
    
    var dessert: Dessert?
    
    let nameLabel = UILabel()
    let dessertImageView = DessertImageView()
    let instructionsCardView = CardView()
    let ingredientsAndMeasuresCardView = CardView()
    
    //MARK: - Inits
    
    init(dessert: Dessert, image: UIImage) {
        super.init(nibName: nil, bundle: nil)
        self.dessert = dessert
        self.dessertImageView.image = image
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDessert()
        setupUI()
    }
    
    //MARK: - Private
    
    @objc func dismiss(_ sender: UIButton) { self.dismiss(animated: true) }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        
        let scrollView = UIScrollView(frame: view.bounds)
        let dismissButton = UIButton(type: .close)
        dismissButton.addTarget(self, action: #selector(dismiss(_:)), for: .touchUpInside)
        nameLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.pinToEdges(of: view)
        
        let contentView = UIView()
        scrollView.addSubview(contentView)
        scrollView.pinToEdges(of: view)
        contentView.pinToEdges(of: scrollView)
        
        contentView.addSubviews(dismissButton, nameLabel, dessertImageView, instructionsCardView, ingredientsAndMeasuresCardView)
        
        let padding: CGFloat = 8
        
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([dismissButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
                                     dismissButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
                                     dismissButton.widthAnchor.constraint(equalToConstant: 50),
                                     dismissButton.heightAnchor.constraint(equalToConstant: 50)])
        
        NSLayoutConstraint.activate([nameLabel.topAnchor.constraint(equalTo: dismissButton.bottomAnchor, constant: padding),
                                     nameLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: padding),
                                     nameLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -padding)])
        
        NSLayoutConstraint.activate([dessertImageView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: padding),
                                     dessertImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
                                     dessertImageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -padding),
                                     dessertImageView.heightAnchor.constraint(equalToConstant: 250)])
        
        NSLayoutConstraint.activate([instructionsCardView.topAnchor.constraint(equalTo: dessertImageView.bottomAnchor, constant: padding),
                                     instructionsCardView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: padding),
                                     instructionsCardView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -padding)])
        
        NSLayoutConstraint.activate([ingredientsAndMeasuresCardView.topAnchor.constraint(equalTo: instructionsCardView.bottomAnchor, constant: padding),
                                     ingredientsAndMeasuresCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
                                     ingredientsAndMeasuresCardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding)])
        
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.bottomAnchor.constraint(equalTo: ingredientsAndMeasuresCardView.bottomAnchor)
        ])
    }
    
    private func setDessert() {
        
        NetworkManager.shared.getDessert(id: dessert!.idMeal) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(var dessert):
                DispatchQueue.main.async {
                    self.nameLabel.text = dessert.strMeal
                    self.instructionsCardView.label.text = dessert.strInstructions
                    self.ingredientsAndMeasuresCardView.label.text = dessert.ingredientsAndMeasures
                }
            case .failure(let error): print(error.rawValue)
            }
        }
    }

}
