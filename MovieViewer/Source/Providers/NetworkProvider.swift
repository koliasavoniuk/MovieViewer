//
//  NetworkProvider.swift
//  MovieViewer
//
//  Created by Mykola Savoniuk on 7/2/18.
//  Copyright © 2018 Mykola Savoniuk. All rights reserved.
//

import Alamofire

class WeatherProvider<ModelType>: ObservableObject
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
                
        }
    }
    
//    func execute() {
//        self.request(with: self.url, parameters: self.parameters) { result in
//            switch result {
//            case let .success(data):
//
//                do {
//                    let decoder = JSONDecoder()
//                    let weatherData = try decoder.decode(ModelType.self, from: data)
//
//                    self.result = weatherData
//                    self.state = .didLoad
//
//                } catch {
//                    self.state = .failLoading(error: Strings.cannot_parse_json.rawValue)
//                }
//
//            case .failure(let error):
//                self.state = .failLoading(error: String(describing: error))
//            }
//        }
//
//    }
}
