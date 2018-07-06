//
//  MoviesModel.swift
//  MovieViewer
//
//  Created by Mykola Savoniuk on 7/4/18.
//  Copyright © 2018 Mykola Savoniuk. All rights reserved.
//

import Foundation

struct MoviesList: Decodable {
    let page: Int
    let totalResults: Int
    let totalPages: Int
    let movies: [Movie]
    
    enum CodingKeys: String, CodingKey {
        case page
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case movies = "results"
    }
}

struct Movie: Decodable {
    let id: Int
    let language: String
    let title: String
    let originalTitle: String
    let overview: String
    let popularity: Double
    let releaseDate: String
    let averageVote: Double
    
    enum CodingKeys: String, CodingKey {
        case id
        case language = "original_language"
        case title
        case originalTitle = "original_title"
        case overview
        case popularity
        case releaseDate = "release_date"
        case averageVote = "vote_average"
    }
}
