//
//  DetailMovieRequest.swift
//  tmdb-app
//
//  Created by Adie on 02/01/23.
//

import UIKit

enum DetailMovieRequest {
    case getMovie(id: Int)
    case getTrailer(id: Int)
    case getReview(id: Int)
}

extension DetailMovieRequest: BaseRequestProtocol {
    var path: String {
        switch self {
        case .getMovie(let id):
            return "/movie/\(id)"
        case .getTrailer(id: let id):
            return "/movie/\(id)/videos"
        case .getReview(id: let id):
            return "/movie/\(id)/reviews"
        }
    }

    var method: HTTPMethod {
        switch self {
        default:
            return .get            
        }
    }
}
