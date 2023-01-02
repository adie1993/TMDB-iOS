//
//  DetailMovieCoordinator.swift
//  tmdb-app
//
//  Created by Adie on 02/01/23.
//

import UIKit

final class DetailMovieCoordinator: Coordinator {

    private let navigationController: UINavigationController
    private var controller: UIViewController?
    
    init(navigationController: UINavigationController, movie: Movie) {
        self.navigationController = navigationController
        let viewModel = DetailMovieViewModel(movie: movie)
        let vc = DetailMovieVC(viewModel: viewModel)
        controller = vc
    }

    func start() {
        guard let vc = controller else { return }
        vc.modalPresentationStyle = .pageSheet
        navigationController.present(vc, animated: true)
    }
}
