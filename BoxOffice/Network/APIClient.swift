//
//  APIClient.swift
//  BoxOffice
//
//  Created by Hyeontae on 17/04/2019.
//  Copyright © 2019 onemoon. All rights reserved.
//

import Foundation

enum boxOfficeAPI {
    case movieList
    case movieDetail(movieId: String)
    case comments(movieId: String)
    
}

class APIClient {
    
    // Rest of code
    
    
    func buildURLRequest<T: APIRequest>(for request: T) throws -> URLRequest {
        return try URLRequestBuilder(with: request.host, path: request.path)
            .set(method: request.method)
            .set(query: request.query)
            .set(body: request.body)
            .build()
    }
    
    
    
}

