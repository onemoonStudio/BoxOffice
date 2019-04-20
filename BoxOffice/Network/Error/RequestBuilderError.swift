//
//  RequestBuilderError.swift
//  BoxOffice
//
//  Created by Hyeontae on 20/04/2019.
//  Copyright © 2019 onemoon. All rights reserved.
//

import Foundation

enum RequestBuilderError: Error {
    case hostString(message: String)
    case queryError(message: String)
    
    static var checkErrorString: String {
        let errorString =
        """
        ######################
        Error Occur With RequestBuilder
        ######################
        """
        return errorString
    }
}
