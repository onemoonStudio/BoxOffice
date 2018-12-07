//
//  Model.swift
//  BoxOffice
//
//  Created by Hyeontae on 06/12/2018.
//  Copyright © 2018 onemoon. All rights reserved.
//

import Foundation

struct APIResponse: Codable {
    let movies: [MovieData]
    let order_type: Int
}

// 0: 예매율(default) 1: 큐레이션 2: 개봉일
// Request Sample http://connect-boxoffice.run.goorm.io/movies?order_type=1
//
//{
//    grade: 12,
//    thumb: "http://movie.phinf.naver.net/20171201_181/1512109983114kcQVl_JPEG/movi
//    e_image.jpg?type=m99_141_2",
//    reservation_grade: 1, title: "신과함께-죄와벌", reservation_rate: 35.5, user_rating: 7.98, date: "2017-12-20",
//    id: "5a54c286e8a71d136fb5378e"
//},

struct MovieData: Codable {
    let grade: Int
    let thumb: String
    let reservation_grade: Int
    let title: String
    let reservation_rate: Double
    let user_rating: Double
    let date: String
    let id: String
    
    var infoString: String {
        return "평점 : \(self.user_rating) 예매순위 : \(self.reservation_grade) 예매율 : \(self.reservation_rate)"
    }
    var openingString: String {
        return "개봉일 : \(self.date)"
    }
}


//
// Request Sample http://connect-boxoffice.run.goorm.io/movie?id=5a54c286e8a71d136fb5378e
//
//{
//    audience: 11676822,
//    grade: 12,
//    actor: "하정우(강림), 차태현(자홍), 주지훈(해원맥), 김향기(덕춘)",
//    duration: 139,
//    reservation_grade: 1,
//    title: "신과함께-죄와벌",
//    reservation_rate: 35.5,
//    user_rating: 7.98,
//    date: "2017-12-20",
//    director: "김용화",
//    id: "5a54c286e8a71d136fb5378e",
//    image: "http://movie.phinf.naver.net/20171201_181/1512109983114kcQVl_JPEG/movi
//    e_image.jpg",
//    synopsis: "저승 법에 의하면, (중략) 고난과 맞닥뜨리는데... 누구나 가지만 아무도 본 적 없는 곳, 새로
//    운 세계의 문이 열린다!", genre: "판타지, 드라마"
//}

struct MovieDetail: Codable {
    var hello: String
}

//
// Request Sample http://connect-boxoffice.run.goorm.io/comments?movie_id=5a54c286e8a71d136fb5378e
//
//{
//    rating: 10,
//    timestamp: 1515748870.80631,
//    writer: "두근반 세근반",
//    movie_id: "5a54c286e8a71d136fb5378e",
//    contents:"정말 다섯 번은 넘게 운듯 ᅲᅲᅲ 감동 쩔어요.꼭 보셈 두 번 보셈"
//},

