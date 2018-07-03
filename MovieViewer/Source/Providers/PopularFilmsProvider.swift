//
//  PopularFilmsProvider.swift
//  MovieViewer
//
//  Created by Mykola Savoniuk on 7/3/18.
//  Copyright © 2018 Mykola Savoniuk. All rights reserved.
//

import Foundation


class PopularFilmsProvider: ObservableObject, NetworkProvider {
    // MARK: - Properties
    var task = URLSessionDataTask()
    
    // MARK: - Internal
    func preparedURL() -> URL {
        let base = NetworkHandler.endpointString(endpoint: .popularMovies)
        let additional = Parameters.apiKey + "=\(NetworkHandler.APIKey)"
        
        return URL(string: base + additional)!
    }
    
    func preparedRequest(url: URL) -> URLRequest {
        return URLRequest(url: url)
    }
    
    func fillModel(with result: [String : AnyObject]) {
        print(result)
    }
}
