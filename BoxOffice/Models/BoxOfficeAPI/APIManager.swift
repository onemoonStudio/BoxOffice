//
//  APIManager.swift
//  BoxOffice
//
//  Created by Hyeontae on 19/04/2019.
//  Copyright © 2019 onemoon. All rights reserved.
//

import Foundation

final class APIManager {
    static let sharedInstance = APIManager()
    private let networkHandler = NetworkHandler<boxOfficeAPI>()
    private var previousOrderType: Int = 0
    public var movieDataContainer = Array<MovieData>()
    // UpdateMovieData 는 없애야 한다 -> 애초에 이미지 크기가 얼마인지도 모르고 모든 양의 데이터를 한꺼번에 받아오는 것은 효율적이지 못함
    
    private init() {
        
    }
    
    // 싱글턴 패턴을 이용, 필요하지 않은 경우에는 요청을 보내지 않는다.
    func movieData(checkContainer: Bool, orderType: Int, completion: @escaping (_ data: [MovieData]?, _ error: Bool) -> Void) {
        
        if checkContainer && !movieDataContainer.isEmpty && orderType == previousOrderType {
            completion(movieDataContainer, false)
        }
        
        networkHandler.request(.movies(orderType: orderType)) { [weak self] (data) in
            do {
                guard let self = self,
                    let data = data
                    else { throw NetworkHandlerError.dataIsNil }
                let apiResponse: APIResponse = try JSONDecoder().decode(APIResponse.self, from: data)
                self.movieDataContainer = apiResponse.movies
                self.previousOrderType = orderType
                completion(self.movieDataContainer, false)
            } catch {
                if case NetworkHandlerError.dataIsNil = error {
                    print(NetworkHandlerError.checkErrorString)
                    print("data is nil")
                } else {
                    print("decode Error")
                    print(error.localizedDescription)
                }
                completion(nil,true)
            }
        }
    }
    
    func imageData(url: String, completion: @escaping (_ data: Data?) -> Void )  {
        networkHandler.simpleRequest(url: url) { (data) in
            if let data = data {
                completion(data)
            } else {
                completion(nil)
            }
        }
    }

}
