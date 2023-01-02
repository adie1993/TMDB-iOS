//
//  UIViewController+Extension.swift
//  tmdb-app
//
//  Created by Adie on 02/01/23.
//

import UIKit

extension UIViewController {
    
    func showAlertView(withTitle title: String, andMessage message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) -> Void in
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func showActionAlert(message: String, action: @escaping () -> Void) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(
            UIAlertAction(title: "Try Again", style: .default) { _ in
                action()
            }
        )
        alert.addAction(
            UIAlertAction(title: "Cancel", style: .cancel) { [weak self] _ in
                self?.dismiss(animated: true)
            }
        )
        present(alert, animated: true, completion: nil)
    }
    
    func removeSpinner(on view: UIView) {
        let spinner = view.subviews.compactMap { $0 as? UIActivityIndicatorView }.first
        spinner?.stopAnimating()
    }
    
    func showSpinner(on view: UIView, size: UIActivityIndicatorView.Style = .large) {
        if let spinner = view.subviews.compactMap({ $0 as? UIActivityIndicatorView }).first {
            spinner.startAnimating()
        } else {
            addSpinner(in: view, size: size)
        }
    }

    private func addSpinner(in view: UIView, size: UIActivityIndicatorView.Style) {
        let loadingView: UIActivityIndicatorView = {
            let activityIndicator = UIActivityIndicatorView()
            activityIndicator.style = size
            activityIndicator.isOpaque = true
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            return activityIndicator
        }()

        view.addSubview(loadingView)

        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        loadingView.startAnimating()
    }
}
