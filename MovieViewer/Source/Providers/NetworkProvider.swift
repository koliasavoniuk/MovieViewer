//
//  NetworkProvider.swift
//  MovieViewer
//
//  Created by Mykola Savoniuk on 7/6/18.
//  Copyright © 2018 Mykola Savoniuk. All rights reserved.
//

import Foundation
import Alamofire

class NetworkProvider<ModelType>: ObservableObject
    where ModelType: Decodable
{
    var result: ModelType?
    let url: URL
    let parameters: [String: String]
    
    init(with url: URL, parameters: [String: String]) {
        self.url = url
        self.parameters = parameters
    }
    
    func execute() {
        Alamofire
            .request(
                url,
                method: .get,
                parameters: parameters
            )
            .validate()
            .responseJSON { (response) -> Void in
                DispatchQueue.global(qos: .background).async {
                    switch response.result {
                    case .success(_):
                        response.data.map {
                            self.parse(with: $0)
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
        }
    }
    
    private func parse(with data: Data) {
        do {
            let decoder = JSONDecoder()
            let moviesData = try decoder.decode(ModelType.self, from: data)

            self.result = moviesData
            self.state = .didLoad

        } catch {
            self.state = .failLoading(error: Strings.cannot_parse_json.rawValue)
        }
    }
}
