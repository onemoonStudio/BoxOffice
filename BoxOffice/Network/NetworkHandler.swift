//
//  APIClient.swift
//  BoxOffice
//
//  Created by Hyeontae on 17/04/2019.
//  Copyright © 2019 onemoon. All rights reserved.
//

import Foundation

class NetworkHandler<ServerAPI: APIRequest> {
    
    typealias CompletionCallback = (_ data: Data, _ responseState: ResponseStatus, _ statusCode: Int) -> Void
    
    func request(_ api: ServerAPI, completion: @escaping CompletionCallback ) -> Void {
        do {
            let urlRequest = try buildURLRequest(for: api)
            let urlSession: URLSession = URLSession(configuration: .default)
            let dataTask = urlSession.dataTask(with: urlRequest) { (data, urlResponse, error) in
                do {
                    if let error = error {
                        fatalError(error.localizedDescription)
                    }
                    guard let httpURLResponse = urlResponse as? HTTPURLResponse else {
                        throw NetworkHandlerError.httpURLResponse(message: "fail to HTTPURLResponse casting")
                    }
                    let responseState = ResponseStatus(with: httpURLResponse)
                    guard let data = data else {
                        throw NetworkHandlerError.dataIsNil
                    }
                    switch responseState {
                    case .continueCode, .success:
                        completion(data, responseState, httpURLResponse.statusCode)
                    case .redirect, .badRequest, .serverError:
                        throw NetworkHandlerError.notSuccessState(status: httpURLResponse.statusCode)
                    }
                } catch (let error) {
                    // MARK: - Network Error
                    if let NetworkError = error as? NetworkHandlerError {
                        print(NetworkHandlerError.checkErrorString)
                        switch NetworkError {
                        case .errorWithRequest(let err, let msg):
                            print(err.localizedDescription)
                            print("message : \(msg)")
                        case .dataIsNil:
                            print("data is nil")
                        case .httpURLResponse(let msg):
                            print(msg)
                        case .notSuccessState(let statusCode):
                            print("status code is \(statusCode)")
                        }
                    } else {
                        print("Unexpected Error! with Network")
                        print(error.localizedDescription)
                    }
                }
            }
            dataTask.resume()
        } catch (let error) {
            // MARK: - builder Error
            if let err = error as? RequestBuilderError {
                print(RequestBuilderError.checkErrorString)
                switch err {
                case .hostString(let msg):
                    print(msg)
                case .queryError(let msg):
                    print(msg)
                }
            } else {
                print("Unexpected Error! with RequestBuilder")
                print(error.localizedDescription)
            }
        }
    }
    
    private func buildURLRequest(for request: ServerAPI) throws -> URLRequest {
        var builder: URLRequestBuilder =
            try URLRequestBuilder(with: request.host, path: request.path)
        builder.set(method: request.method)
        builder.set(query: request.query)
        builder.set(body: request.body)
        
        return try builder.build()
    }
}


