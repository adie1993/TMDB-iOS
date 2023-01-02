//
//  TrailerResponse.swift
//  tmdb-app
//
//  Created by Adie on 02/01/23.
//

import UIKit

struct TrailerResponse: Decodable {
    let id: Int
    let results: [Trailer]

    enum CodingKeys: String, CodingKey {
        case id
        case results
    }
}

struct Trailer: Decodable {
    let key: String
    let site: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case key
        case site
        case name
    }
}
