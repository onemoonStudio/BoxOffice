//
//  Request.swift
//  BoxOffice
//
//  Created by Hyeontae on 17/04/2019.
//  Copyright © 2019 onemoon. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case post = "POST"
    case get = "GET"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

protocol APIRequest {
    var host: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var query: [String: String]? { get }
    var body: [String: Any]? { get }
    var headers: [String: Any]? { get }
}
