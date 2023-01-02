//
//  ErrorHandler.swift
//  tmdb-app
//
//  Created by Adie on 02/01/23.
//

enum ErrorHandler: Error {
    case decode
    case invalidURL
    case noResponse
    case unauthorized
    case notFound
    case badRequest
    case serverError
    case timeOut
    case unknown

    var customMessage: String {
        switch self {
        case .decode:
            return "Error while decode"
        case .invalidURL:
            return "Invalid URL"
        case .noResponse:
            return "No internet"
        case .badRequest:
            return "Bad request"
        case .unauthorized:
            return "Unauthorized"
        case .notFound:
            return "URL not found"
        case .serverError:
            return "Server Error"
        case .timeOut:
            return "Request timeout"
        default:
            return "Unknown error"
        }
    }
}
