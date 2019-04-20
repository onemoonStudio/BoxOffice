//
//  Enum+BoxOfficeAPI.swift
//  BoxOffice
//
//  Created by Hyeontae on 19/04/2019.
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
