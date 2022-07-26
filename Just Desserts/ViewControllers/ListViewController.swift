//
//  ListViewController.swift
//  Just Desserts
//
//  Created by Eddie Caballero on 5/25/22.
//

import UIKit

class ListViewController: UIViewController {
    
    var viewModel: ListViewModel!
    weak var coordinator: MainCoordinator?
    
    enum Section { case main }
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Dessert>!
    
    let activityIndicator = UIActivityIndicatorView(style: .large)
    
    //MARK: - Inits
    
    init(viewModel: ListViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupOnUpdate()
    }
    
    //MARK: - Private
    
    private func setupOnUpdate() {
        viewModel.onUpdate = { [weak self] desserts in
            guard let self = self else { return }
            guard let desserts = desserts else { return }
            
            self.updateData(on: desserts)
        }
    }
    
    private func setupUI() {
        setupCollectionView()
        setupDataSource()
        setupActivityIndicator()
        viewModel.getDesserts()
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
            let container = DependencyContainer()
            let viewModel = container.makeDessertCellViewModel(service: DessertService(), dessert: dessert, placeholderImage: DessertImage.placeholder)
            cell.set(viewModel: viewModel)
            return cell
        })
    }

}

//MARK: - UICollectionViewDelegate

extension ListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dessert = viewModel.desserts[indexPath.item]
        let cell = collectionView.cellForItem(at: indexPath) as! DessertCell
        let image: UIImage = cell.dessertImageView.image ?? DessertImage.placeholder
        
        coordinator?.showDetailsViewController(service: DessertService(), dessert: dessert, image: image)
    }
}

