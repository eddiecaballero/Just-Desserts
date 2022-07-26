//
//  DependencyContainer.swift
//  Just Desserts
//
//  Created by Eddie Caballero on 7/25/22.
//

import UIKit

//MARK: - Factory Protocols

protocol ViewModelFactory {
    func makeListViewModel() -> ListViewModel
    func makeDetailsViewModel(service: DessertServiceProtocol, dessert: Dessert, image: UIImage) -> DetailsViewModel
    
    func makeDessertCellViewModel(service: DessertServiceProtocol, dessert: Dessert, placeholderImage: UIImage) -> DessertCellViewModel
}

protocol ViewControllerFactory {
    func makeListViewController() -> ListViewController
    func makeDetailsViewController(viewModel: DetailsViewModel) -> DetailsViewController
}

//MARK: - Container

class DependencyContainer {}

//MARK: - Factory Implementations

extension DependencyContainer: ViewModelFactory {
    func makeListViewModel() -> ListViewModel {
        return ListViewModel(service: DessertService())
    }
    
    func makeDetailsViewModel(service: DessertServiceProtocol, dessert: Dessert, image: UIImage) -> DetailsViewModel {
        return DetailsViewModel(service: service, dessert: dessert, image: image)
    }
    
    func makeDessertCellViewModel(service: DessertServiceProtocol, dessert: Dessert, placeholderImage: UIImage) -> DessertCellViewModel {
        return DessertCellViewModel(service: service, dessert: dessert, placeholderImage: placeholderImage)
    }
}

extension DependencyContainer: ViewControllerFactory {
    func makeListViewController() -> ListViewController {
        return ListViewController(viewModel: makeListViewModel())
    }
    
    func makeDetailsViewController(viewModel: DetailsViewModel) -> DetailsViewController {
        return DetailsViewController(viewModel: viewModel)
    }
}
