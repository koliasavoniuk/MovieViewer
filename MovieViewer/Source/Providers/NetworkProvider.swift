//
//  NetworkProvider.swift
//  MovieViewer
//
//  Created by Mykola Savoniuk on 7/2/18.
//  Copyright © 2018 Mykola Savoniuk. All rights reserved.
//

import Foundation

enum HttpMethod: String {
    case post = "POST"
    case delete = "DELETE"
}

enum ServerResult {
    case success([String:AnyObject])
    case successArray([AnyObject])
    case failure(Error)
}

enum ParsingError: Error {
    case invalidJSONData
}

protocol NetworkProvider {
    var session: URLSession { get }
    var task: URLSessionDataTask { set get }
    
    mutating func execute()
    func cancel()
    func preparedURL() -> URL
    func preparedRequest(url: URL) -> URLRequest
    func createBody(parameters: [String: String]?, boundary: String, data: Data, mimeType: String, filename: String, fileKey: String) -> Data
    func processRequest(data: Data?, error: Error?) -> ServerResult
    func serverResponse(fromJSON data: Data) -> ServerResult
    func fillModel(with result: [String:AnyObject])
    func fillModel(arrayResult: [AnyObject])
}

extension NetworkProvider where Self: ObservableObject {
    var session: URLSession {
        return URLSession(configuration: URLSessionConfiguration.default)
    }
    
    mutating func execute() {
        if state == .willLoad { return }
        state = .willLoad
        
        let url = preparedURL()
        let request = preparedRequest(url: url)
        
        task = session.dataTask(with: request, completionHandler: { [weak self] (data, response, error) -> Void in
            if let urlResponse = response {
                let httpURLResponse = urlResponse as! HTTPURLResponse
                let statusCode = httpURLResponse.statusCode
                let successfullCodes = 200...404
                if !successfullCodes.contains(statusCode) {
                    let errorString = "Wrong status code = \(statusCode)"
                    self?.state = .failLoading(error: errorString)
                    
                    return
                }
            }
            guard let result = self?.processRequest(data: data, error: error) else {
                self?.state = .failLoading(error: "Bad Data from server response.")
                
                return
            }
            switch result {
            case .success(let json):
                self?.fillModel(with: json)
            case .successArray(let jsonArray):
                self?.fillModel(arrayResult: jsonArray)
            case let .failure(error):
                let errorString = "Server response error = \(error)"
                self?.state = .failLoading(error: errorString)
            }
        })
        
        task.resume()
    }
    
    func cancel() {
        if state == .willLoad {
            task.cancel()
            state = .notLoaded
        }
    }
    
    func createBody(parameters: [String: String]?, boundary: String, data: Data, mimeType: String, filename: String, fileKey: String) -> Data {
        var body = Data()
        let boundaryPrefix = "--\(boundary)\r\n"
        
        body.append(boundaryPrefix)
        body.append("Content-Disposition: form-data; name=\"\(fileKey)\"; filename=\"\(filename)\"\r\n")
        body.append("Content-Type: \(mimeType)\r\n\r\n")
        body.append(data)
        body.append("\r\n")
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.append(boundaryPrefix)
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.append("\(value)\r\n")
            }
        }
        body.append("--\(boundary)--\r\n")
        
        return body
    }
    
    func processRequest(data: Data?, error: Error?) -> ServerResult {
        guard let jsonData = data else {
            return .failure(error!)
        }
        
        return serverResponse(fromJSON: jsonData)
    }
    
    func serverResponse(fromJSON data: Data) -> ServerResult {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            guard let jsonDictionary = jsonObject as? [String:AnyObject] else {
                guard let jsonArray = jsonObject as? [AnyObject] else {
                    return .failure(ParsingError.invalidJSONData)
                }
                return .successArray(jsonArray)
            }
            return .success(jsonDictionary)
        } catch let error {
            return .failure(error)
        }
    }
    
    func fillModel(arrayResult: [AnyObject]) {
        
    }
}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}

