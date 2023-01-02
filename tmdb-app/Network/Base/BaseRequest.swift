//
//  BaseRequest.swift
//  tmdb-app
//
//  Created by Adie on 02/01/23.
//

import Foundation

struct Resource<T: Decodable> {
    var request: BaseRequestProtocol
}

protocol BaseRequestProtocol {
    var path: String { get }
    var body: [String: Any]? { get }
    var header: [String: String] { get }
    var method: HTTPMethod { get }
    var queryParams: [URLQueryItem]? { get }
    var timeout: TimeInterval { get }
    var completeURL: URL { get }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

extension BaseRequestProtocol {
    var body: [String: Any]? {
        return nil
    }

    var header: [String: String] {
        return [
            "Authorization": "Bearer \(Constant.apiKey)"
        ]
    }

    var queryParams: [URLQueryItem]? {
        return nil
    }

    var timeout: TimeInterval {
        return 30
    }

    var completeURL: URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.themoviedb.org"
        urlComponents.path = "/3" + path
        urlComponents.queryItems = queryParams

        return urlComponents.url!
    }
}

