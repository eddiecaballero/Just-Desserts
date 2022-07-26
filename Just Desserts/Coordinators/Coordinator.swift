//
//  Coordinator.swift
//  Just Desserts
//
//  Created by Eddie Caballero on 7/25/22.
//

import Foundation
import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get }
    var navigationController: UINavigationController { get }
    
    func start()
}

class MainCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController = UINavigationController()
    
    var rootViewController: UIViewController?
    
    func start() {
        let listViewController = ListViewController(viewModel: ListViewModel(service: DessertService()))
        listViewController.coordinator = self
        rootViewController = listViewController
    }
    
    func showDetailsViewController(service: DessertService, dessert: Dessert, image: UIImage) {
        let viewModel = DetailsViewModel(service: service, dessert: dessert, image: image)
        let destinationViewController = DetailsViewController(viewModel: viewModel)
        navigationController = UINavigationController(rootViewController: destinationViewController)
        rootViewController?.present(navigationController, animated: true)
    }
}
