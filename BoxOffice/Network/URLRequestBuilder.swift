//
//  URLRequestBuilder.swift
//  BoxOffice
//
//  Created by Hyeontae on 17/04/2019.
//  Copyright © 2019 onemoon. All rights reserved.
//

import Foundation

class URLRequestBuilder {
    var host: String
    var path: String?
    var method: HTTPMethod = .get
    var query: [String: String]?
    var body: [String: Any]?
    var headers: [String: String]?
    
    init(with host: String, path: String?) {
        self.host = host
        self.path = path
    }
    
    func set(method: HTTPMethod) -> Self {
        self.method = method
        return self
    }
    
    func set(path: String) -> Self {
        self.path = path
        return self
    }
    
    func set(headers: [String: String]?) -> Self {
        self.headers = headers
        return self
    }
    
    func set(query: [String: String]?) -> Self {
        self.query = query
        return self
    }
    
    func set(body: [String: Any]?) -> Self {
        self.body = body
        return self
    }
    
    func build() throws -> URLRequest {
        do {
            guard var url = URL(string: host) else {
                throw RequestBuilderError.hostString(message: "hostString is awkward")
            }
            if let path = path {
                url.appendPathComponent(path)
            }
            if let query = query {
                try url.appendQueryComponent(query)
            }
            var urlRequest = URLRequest(url: url,
                                        cachePolicy: .reloadIgnoringLocalCacheData,
                                        timeoutInterval: 100)
            if let body = body {
                let bodyData = NSKeyedArchiver.archivedData(withRootObject: body)
                urlRequest.httpBody = bodyData
            }
            urlRequest.httpMethod = method.rawValue
            headers?.forEach {
                urlRequest.addValue($1, forHTTPHeaderField: $0)
            }
            return urlRequest
        } catch (let err ){
            throw err
        }
    }
}

fileprivate extension URL {
    mutating func appendQueryComponent(_ queryComponents: [String: String]) throws {
        var queryItems: [URLQueryItem] = []
        queryComponents.forEach {
            queryItems.append(URLQueryItem(name: $0, value: $1))
        }
        var tempURLComponents = URLComponents(url: self, resolvingAgainstBaseURL: true)!
        tempURLComponents.queryItems = queryItems
        guard let url = tempURLComponents.url else {
            throw RequestBuilderError.queryError(message: "Fail to build URL with Query")
        }
        self = url
    }
}

fileprivate enum RequestBuilderError: Error {
    case hostString(message: String)
    case queryError(message: String)
}
