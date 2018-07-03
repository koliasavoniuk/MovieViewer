//
//  NetworkHandler.swift
//  MovieViewer
//
//  Created by Mykola Savoniuk on 7/2/18.
//  Copyright © 2018 Mykola Savoniuk. All rights reserved.
//

import Foundation

struct NetworkHandler {
    static let defaultURL = "https://api.themoviedb.org/3"
    static let APIKey = "17bba4bd147430704b6eaca3b4709a66"
    
    static func endpointURL(endpoint: Endpoint) -> URL {
        return URL(string: (defaultURL + endpoint.rawValue))!
    }
    
    static func endpointString(endpoint: Endpoint) -> String {
        return defaultURL + endpoint.rawValue
    }
}

enum Endpoint: String {
    case popularMovies = "/movie/popular?"
}

struct Parameters {
    static let apiKey = "api_key"
}
