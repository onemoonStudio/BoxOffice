//
//  DetailRequest.swift
//  BoxOffice
//
//  Created by Hyeontae on 10/12/2018.
//  Copyright © 2018 onemoon. All rights reserved.
//

import Foundation

let didReceiveMovieDetailData: Notification.Name = Notification.Name.init("didReceiveDetailData")
let didRecieveCommentData: Notification.Name = Notification.Name.init("didRecieveCommentData")
let detailNetworkError: Notification.Name = Notification.Name.init("detailNetworkError")
let detailCommentsNetworkError: Notification.Name = Notification.Name.init("detailCommentsError")

func detailRequest(_ id: String) {
    guard let detailAPIURL = URL(string: "http://connect-boxoffice.run.goorm.io/movie?id=\(id)") else { return }
    let session: URLSession = URLSession(configuration: .default)
    let dataTask: URLSessionDataTask = session.dataTask(with: detailAPIURL) {
        (data: Data? , response: URLResponse? , error: Error? ) in
        
        if let error = error {
            print(error.localizedDescription)
            NotificationCenter.default.post(name: detailNetworkError, object: nil, userInfo:nil)
            return
        }
        guard let data = data else { return }
        
        do {
            let apiResponse: MovieDetail = try JSONDecoder().decode(MovieDetail.self, from: data)
            if apiResponse.date == "" {
                NotificationCenter.default.post(name: detailNetworkError, object: nil, userInfo:nil)
                return
            }
            guard let imageURL: URL = URL(string: apiResponse.image) else { return }
            guard let imageData: Data = try? Data(contentsOf: imageURL) else { return }
            
            NotificationCenter.default.post(name: didReceiveMovieDetailData, object: nil, userInfo: ["apiResponse" : apiResponse , "imageData" : imageData])
            
        } catch (let netErr) {
            print(netErr.localizedDescription)
            NotificationCenter.default.post(name: detailNetworkError, object: nil, userInfo:nil)
        }
    }
    dataTask.resume()
}




func detailCommentRequest(_ id: String) {
    guard let detailAPIURL = URL(string: "http://connect-boxoffice.run.goorm.io/comments?movie_id=\(id)") else { return }
    let session: URLSession = URLSession(configuration: .default)
    let dataTask: URLSessionDataTask = session.dataTask(with: detailAPIURL) {
        (data: Data? , response: URLResponse? , error: Error? ) in

        if let error = error {
            print(error.localizedDescription)
            NotificationCenter.default.post(name: detailCommentsNetworkError, object: nil, userInfo:nil)
            return
        }
        guard let data = data else { return }
        
        do {
            let apiResponse: CommentResponse = try JSONDecoder().decode(CommentResponse.self, from: data)
            if apiResponse.comments.count == 0 {
                NotificationCenter.default.post(name: detailCommentsNetworkError, object: nil, userInfo:nil)
                return
            }
            let commentDatas: [MovieComment] = apiResponse.comments
            NotificationCenter.default.post(name: didRecieveCommentData, object: nil, userInfo:["commentDatas" : commentDatas])
            
        } catch (let netErr) {
            print(netErr.localizedDescription)
            NotificationCenter.default.post(name: detailCommentsNetworkError, object: nil, userInfo:nil)
        }
    }
    dataTask.resume()
}
