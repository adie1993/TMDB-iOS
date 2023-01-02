//
//  PopularMoviesProvider.swift
//  tmdb-app
//
//  Created by Adie on 02/01/23.
//

import Foundation

enum PopularMoviesRequest {
    case getPopularMovies(page: Int)
}

extension PopularMoviesRequest: BaseRequestProtocol {
    var path: String {
        switch self {
        case .getPopularMovies:
            return "/movie/popular"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getPopularMovies:
            return .get
        }
    }

    var queryParams: [URLQueryItem]? {
        switch self {
        case .getPopularMovies(let page):
            return [
                URLQueryItem(name: "page", value: "\(page)")
            ]
        }
    }
}

