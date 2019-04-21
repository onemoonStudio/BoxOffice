//
//  APIClient.swift
//  BoxOffice
//
//  Created by Hyeontae on 17/04/2019.
//  Copyright © 2019 onemoon. All rights reserved.
//

import Foundation

class NetworkHandler<ServerAPI: APIRequest> {
    
//    typealias CompletionCallback = (_ data: Data, _ responseState: ResponseStatus, _ statusCode: Int) -> Void
    // response state 를 던질 필요가 있을까?
    typealias CompletionCallback = (_ data: Data?) -> Void
    // error 또한 던질 필요가 없다? 어차피 여기서 에러 처리 다 한다. nil이 가면 통신이 실패한 것
    typealias ErrorHandlingTuple = (status: ResponseStatus,data: Data?, statusCode: Int)
    
    func request(_ api: ServerAPI, completion: @escaping CompletionCallback ) -> Void {
        do {
            let urlRequest = try buildURLRequest(for: api)
            let urlSession: URLSession = URLSession(configuration: .default)
            let dataTask = urlSession.dataTask(with: urlRequest) { (data, urlResponse, error) in
                do {
                    if let error = error {
                        throw NetworkHandlerError.errorWithRequest(err: error, message: "request Error")
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
                        completion(data)
                    case .redirect, .badRequest, .serverError:
                        completion(nil)
                        throw NetworkHandlerError.notSuccessState(status: httpURLResponse.statusCode)
                    }
                } catch (let error) {
                    // MARK: - Network Error
                    self.requestErrorHandling(error)
                    completion(nil)
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
            completion(nil)
        }
    }
    
    func simpleRequest(url: String, completion: @escaping (_ data: Data?) -> Void) {
        do {
            let simpleRequest = try buildSimpleURLRequest(for: url)
            let dataTask = URLSession(configuration: .default).dataTask(with: simpleRequest) { [weak self] (data, response, error) in
                guard let self = self else { return }
                do {
                    let afterErrorHandling: ErrorHandlingTuple =
                        try self.dataTaskErrorHandlng(data, response, error)
                    
                    switch afterErrorHandling.status {
                    case .continueCode, .success:
                        completion(afterErrorHandling.data)
                    case .redirect, .badRequest, .serverError:
                        completion(nil)
                        throw NetworkHandlerError.notSuccessState(status: afterErrorHandling.statusCode)
                    }
                } catch (let error) {
                    self.requestErrorHandling(error)
                }
            }
            dataTask.resume()
        } catch {
            print("error Occur with simpleRequest builder ")
            completion(nil)
        }
    }
    
    private func buildSimpleURLRequest(for url: String) throws -> URLRequest {
        let builder: URLRequestBuilder = try URLRequestBuilder(with: url)
        return try builder.build()
    }
    
    private func buildURLRequest(for request: ServerAPI) throws -> URLRequest {
        var builder: URLRequestBuilder =
            try URLRequestBuilder(with: request.host, path: request.path)
        builder.set(method: request.method)
        builder.set(query: request.query)
        builder.set(body: request.body)
        
        return try builder.build()
    }
    
    private func requestErrorHandling(_ error: Error) {
        if let NetworkError = error as? NetworkHandlerError {
            print(NetworkHandlerError.checkErrorString)
            switch NetworkError {
            case let .errorWithRequest(err, message):
                // let을 통해 파라미터를 선언해주는 것 말고도 let을 처음에 빼줄 수 도 있다.
                print(err.localizedDescription)
                print("message : \(message)")
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

    private func dataTaskErrorHandlng(
        _ data: Data?,
        _ urlResponse: URLResponse?,
        _ error: Error?) throws -> ErrorHandlingTuple {
        if let error = error {
            throw NetworkHandlerError.errorWithRequest(err: error, message: "request Error")
        }
        guard let httpURLResponse = urlResponse as? HTTPURLResponse else {
            throw NetworkHandlerError.httpURLResponse(message: "fail to HTTPURLResponse casting")
        }
        if data == nil {
            throw NetworkHandlerError.dataIsNil
        }
        
        return (status: ResponseStatus.init(with: httpURLResponse),
                data: data,
                statusCode: httpURLResponse.statusCode )
    }
    
    
}


