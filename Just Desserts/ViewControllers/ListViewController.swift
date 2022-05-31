//
//  ListViewController.swift
//  Just Desserts
//
//  Created by Eddie Caballero on 5/25/22.
//

import UIKit

class ListViewController: UIViewController {
    
    var desserts: [Dessert] = []
    
    enum Section { case main }
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Dessert>!
    
    let activityIndicator = UIActivityIndicatorView(style: .large)
    
    //MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    //MARK: - Private
    
    private func setupUI() {
        setupCollectionView()
        setupActivityIndicator()
        getDesserts()
        setupDataSource()
    }
    
    private func updateUI(with desserts: [Dessert]) {
        self.desserts = desserts
        
        self.updateData(on: self.desserts)
    }
    
    private func updateData(on desserts: [Dessert]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Dessert>()
        snapshot.appendSections([.main])
        snapshot.appendItems(desserts)
        DispatchQueue.main.async { self.dataSource.apply(snapshot, animatingDifferences: true) }
    }
    
    private func flowLayout() -> UICollectionViewFlowLayout {
        let width                       = view.bounds.width
        let padding: CGFloat            = 12
        let minimumItemSpacing: CGFloat = 10
        let availableWidth              = width - (padding * 2) - (minimumItemSpacing * 2)
        let itemWidth                   = availableWidth / 3
        
        let flowLayout                  = UICollectionViewFlowLayout()
        flowLayout.sectionInset         = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize             = CGSize(width: itemWidth, height: itemWidth + 40)
        
        return flowLayout
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: flowLayout())
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(DessertCell.self, forCellWithReuseIdentifier: DessertCell.reuseID)
    }
    
    private func setupActivityIndicator() {
        activityIndicator.color = .systemPink
        activityIndicator.center = collectionView.center
        collectionView.addSubview(activityIndicator)
    }
    
    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Dessert>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, dessert) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DessertCell.reuseID, for: indexPath) as! DessertCell
            cell.set(dessert: dessert)
            return cell
        })
    }
    
    private func getDesserts() {
        activityIndicator.startAnimating()
        NetworkManager.shared.getDesserts() { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async { self.activityIndicator.stopAnimating() }
            
            switch result {
            case .success(let desserts): DispatchQueue.main.async { self.updateUI(with: desserts) }
            case .failure(let error): print(error.rawValue)
            }
        }
    }

}

//MARK: - UICollectionViewDelegate

extension ListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dessert = desserts[indexPath.item]
        let cell = collectionView.cellForItem(at: indexPath) as! DessertCell
        let image: UIImage = cell.dessertImageView.image ?? DessertImage.placeholder!
        
        let destinationViewController = DetailsViewController(dessert: dessert, image: image)
        let navigationController = UINavigationController(rootViewController: destinationViewController)
        present(navigationController, animated: true)
    }
}

