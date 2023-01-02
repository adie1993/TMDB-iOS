//
//  ListPopularCoordinator.swift
//  tmdb-app
//
//  Created by Adie on 02/01/23.
//

import UIKit

protocol ListPopularCoordinatorDelegate: AnyObject {
    func navigateToDetail(data:Movie)
}


final class ListPopularCoordinator: Coordinator {
                
    var navigationController: UINavigationController = .init()
    var controller: UIViewController?
    init() {
        let viewModel = ListPopularViewModel(coordinator: self)
        controller = ListPopularVC(viewModel: viewModel)
        navigationController = UINavigationController(rootViewController: controller!)
    }
    
    
    func start() {
        print(#function)
    }
    
}

extension ListPopularCoordinator : ListPopularCoordinatorDelegate{
    
    func navigateToDetail(data: Movie) {
        let detailCoordinator = DetailMovieCoordinator(navigationController: navigationController, movie: data)
        detailCoordinator.start()
    }    
    
}
