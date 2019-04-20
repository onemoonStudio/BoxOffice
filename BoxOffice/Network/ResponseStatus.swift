//
//  APIResponse.swift
//  BoxOffice
//
//  Created by Hyeontae on 19/04/2019.
//  Copyright © 2019 onemoon. All rights reserved.
//

import Foundation

enum ResponseStatus {
    case continueCode
    case success
    case redirect
    case badRequest
    case serverError
    
    init(with urlResponse: HTTPURLResponse) {
        switch urlResponse.statusCode {
        case 100..<200:
            self = .continueCode
        case 200..<300:
            self = .success
        case 300..<400:
            self = .redirect
        case 400..<500:
            self = .badRequest
        case 500..<600:
            self = .serverError
        default:
            fatalError("status code Error with \(urlResponse.statusCode) statusCode")
        }
    }
}
