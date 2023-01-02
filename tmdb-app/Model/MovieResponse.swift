//
//  MovieResponse.swift
//  tmdb-app
//
//  Created by Adie on 02/01/23.
//

struct MoviesResponse: Decodable {
    let page: Int
    let totalPages: Int
    let totalResults: Int
    let results: [Movie]

    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct Movie: Decodable {
    let id: Int
    let title: String
    let genres: [MovieGenre]?
    let genreIds: [Int]?
    let overview: String
    let releaseDate: String?
    let runtime: Int?
    let voteAverage: Double
    let backdropPath: String?
    let posterPath: String?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case genres
        case genreIds = "genre_ids"
        case overview
        case releaseDate = "release_date"
        case runtime
        case voteAverage = "vote_average"
        case backdropPath = "backdrop_path"
        case posterPath = "poster_path"
    }
}

struct MovieGenre: Decodable {
    let id: Int
    let name: String
}

extension Movie: Equatable {
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        return true
    }
}
