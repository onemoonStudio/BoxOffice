//
//  NetworkError.swift
//  BoxOffice
//
//  Created by Hyeontae on 20/04/2019.
//  Copyright © 2019 onemoon. All rights reserved.
//

import Foundation

enum NetworkHandlerError: Error {
    case errorWithRequest(err: Error, message: String)
    case httpURLResponse(message: String)
    case dataIsNil
    case notSuccessState(status: Int)
    
    static var checkErrorString: String {
        let errorString =
        """
        ######################
        Error Occur With Network
        ######################
        """
        return errorString
    }
}
