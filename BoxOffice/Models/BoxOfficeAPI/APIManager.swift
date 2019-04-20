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
    public var movieDataContainer: [MovieData] = []
    // UpdateMovieData 는 없애야 한다 -> 애초에 이미지 크기가 얼마인지도 모르고 모든 양의 데이터를 한꺼번에 받아오는 것은 효율적이지 못함
    
    private init() {
        
    }
    
    func movieData(checkContainer: Bool, orderType: Int, completion: @escaping (_ data: [MovieData]) -> Void) {
        if checkContainer && !movieDataContainer.isEmpty && orderType == previousOrderType {
            completion(movieDataContainer)
        }
        networkHandler.request(.movies(orderType: orderType)) { [weak self] (data, state, statusCode) in
            do {
                guard let self = self else { return }
                let apiResponse: APIResponse = try JSONDecoder().decode(APIResponse.self, from: data)
                self.movieDataContainer = apiResponse.movies
                self.previousOrderType = orderType
                completion(self.movieDataContainer)
            } catch {
                print("decode Error")
                print(error.localizedDescription)
            }
        }
    }

}
