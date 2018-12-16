//
//  SingletonModel.swift
//  BoxOffice
//
//  Created by Hyeontae on 09/12/2018.
//  Copyright © 2018 onemoon. All rights reserved.
//

import Foundation

let didReceiveDataNotification: Notification.Name = Notification.Name("didReceiveData")
let changeDataOrderNotification: Notification.Name = Notification.Name("changeDataOrder")
let updateDataNotification: Notification.Name = Notification.Name("updateData")
let moviesDataRequestError: Notification.Name = Notification.Name("moviesDataRequestError")

class SingletonData {
    static let sharedInstance = SingletonData()
    
    var movieDatas: [UpdatedMovieData] = []
    var nowOrderType: Int = 1
    
    private init() {
//        self.movieDatas = []
        self.requestData(initRequest: true)
    }
    
    func requestData(initRequest: Bool) {
        
        guard let apiURL = URL(string: "http://connect-boxoffice.run.goorm.io/movies?order_type=0") else { return }
        let session: URLSession = URLSession(configuration: .default)
        let dataTask: URLSessionDataTask = session.dataTask(with: apiURL) {
            (data: Data? , response: URLResponse? , error: Error? ) in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let data = data else { return }
            
            do {
                // refresh controll
                self.movieDatas.removeAll()
                let apiResponse: APIResponse = try JSONDecoder().decode(APIResponse.self, from: data)
                let tempData: [MovieData] = apiResponse.movies
                
                for item in tempData {
                    guard let imageURL = URL(string: item.thumb) else { return }
                    guard let imageData: Data = try? Data(contentsOf: imageURL) else { return }
                    
                    let tempItem: UpdatedMovieData = UpdatedMovieData(item,imageData)
                    self.movieDatas.append(tempItem)
                }
                
                self.orderingData(self.nowOrderType)
                
                if initRequest {
                        NotificationCenter.default.post(name: didReceiveDataNotification, object: nil, userInfo: nil)
                } else {
                        NotificationCenter.default.post(name: updateDataNotification, object: nil, userInfo: nil)
                }
            } catch(let netErr) {
                print(netErr.localizedDescription)
                NotificationCenter.default.post(name: moviesDataRequestError, object: nil, userInfo: nil)
            }
        }
        dataTask.resume()
    }
    
    func orderingData(_ orderType: Int){
        var navigationBarTitle: String
        self.nowOrderType = orderType
        switch orderType {
        case 1:
            self.movieDatas.sort(by: {$0.basic.reservation_rate > $1.basic.reservation_rate})
            navigationBarTitle = "예매율순"
        case 2:
            self.movieDatas.sort(by: { $0.basic.user_rating > $1.basic.user_rating })
            navigationBarTitle = "큐레이션"
        case 3:
            self.movieDatas.sort(by: { self.dataStringToDate($0.basic.date) > self.dataStringToDate($1.basic.date) })
            navigationBarTitle = "개봉일순"
        default:
            navigationBarTitle = "예매율순"
        }
        
        NotificationCenter.default.post(name: changeDataOrderNotification, object: nil, userInfo: ["navigationBarTitle" : navigationBarTitle])
    }
    
    func dataStringToDate(_ dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date: Date = dateFormatter.date(from: dateString) else { return Date() }
        return date
    }
}
