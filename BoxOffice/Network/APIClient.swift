//
//  APIClient.swift
//  BoxOffice
//
//  Created by Hyeontae on 17/04/2019.
//  Copyright © 2019 onemoon. All rights reserved.
//

import Foundation

enum boxOfficeAPI {
    case movies(orderType: Int)
    case movieDetail(movieId: String)
    case comments(movieId: String)
    
}

extension boxOfficeAPI: APIRequest {
    var host: String {
        return "http://connect-boxoffice.run.goorm.io"
    }
    
    var path: String {
        switch self {
        case .movies(_):
            return "/movies"
        case .movieDetail(_):
            return "/movie"
        case .comments(_):
            return "/comments"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var query: [String : String]? {
        switch self {
        case .movies(let orderType):
            return ["order_type": "\(orderType)"]
        case .movieDetail(let movieId):
            return ["id": "\(movieId)"]
        case .comments(let movieId):
            return ["movie_id": "\(movieId)"]
        }
    }
    
    var body: [String : Any]? {
        return nil
    }
    
    var headers: [String : Any]? {
        return nil
    }
    
}

class APIClient<ServerAPI: APIRequest> {
    
    // Rest of code
    
    
    // 내부적으로 리퀘스트를 만드는 용도에만 사용하고 실제로 데이터를 넘기는 부분은 public 을 사용하자
    private func buildURLRequest(for request: ServerAPI) throws -> URLRequest {
        return try URLRequestBuilder(with: request.host, path: request.path)
            .set(method: request.method)
            .set(query: request.query)
            .set(body: request.body)
            .build()
    }
    
//    func buildURLRequest<T: APIRequest>(for request: T) throws -> URLRequest {
//        return try URLRequestBuilder(with: request.host, path: request.path)
//            .set(method: request.method)
//            .set(query: request.query)
//            .set(body: request.body)
//            .build()
//    }
    
    
    
}

