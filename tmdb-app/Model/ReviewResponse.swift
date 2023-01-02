//
//  ReviewResponse.swift
//  tmdb-app
//
//  Created by Adie on 02/01/23.
//

import UIKit

struct ReviewResponse: Decodable {
    let results: [Reviews]

    enum CodingKeys: String, CodingKey {
        case results
    }
}

struct Reviews: Decodable {
    let author: String?
    let authorDetails : AuthorDetail?
    let content: String?
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case author
        case authorDetails = "author_details"
        case content
        case createdAt = "created_at"
    }
}

struct AuthorDetail : Decodable {

    let avatarPath : String?

    enum CodingKeys: String, CodingKey {
        case avatarPath = "avatar_path"
    }

}
