//
//  Constant.swift
//  tmdb-app
//
//  Created by Adie on 02/01/23.
//

import Foundation

enum Constant {
    
    static let apiKey = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJkZjNkZmI3MDZjMGNmZmEzYmZhZTk5N2JjODU3MWI0OSIsInN1YiI6IjYzYWViMGViYzU2ZDJkMDA3YzgyZmQzNSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.6uMZATex7HGgaEg8h8q4A2n-roGddQtQT43oAwWmIfo"
    
    static let notAvailable = "N/A"
    
    enum Images {
        static let posterPlaceholder = "poster-placeholder"
        static let detailPlaceholder = "detail-placeholder"
        static let personPlaceholder = "person-placeholder"
    }
    enum ImageURL {
        static let highQuality = "https://image.tmdb.org/t/p/w780"
        static let mediumQuality = "https://image.tmdb.org/t/p/w342"
        static let lowQuality = "https://image.tmdb.org/t/p/w154"
        static let posterPlaceholder = "https://critics.io/img/movies/poster-placeholder.png"
        static let backdropPlaceholder = "https://image.xumo.com/v1/assets/asset/XM05YG2LULFZON/600x340.jpg"
    }
}
