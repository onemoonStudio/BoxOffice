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

struct UpdatedMovieData {
    var basic: MovieData
    var imageData: Data
    
    init(_ basic: MovieData , _ imageData: Data) {
        self.basic = basic
        self.imageData = imageData
    }
    
    var infoString: String {
        return "평점 : \(self.basic.user_rating) 예매순위 : \(self.basic.reservation_grade) 예매율 : \(self.basic.reservation_rate)"
    }
    var collectionViewInfoString: String {
        return "\(self.basic.reservation_grade)위(\(self.basic.user_rating)) / \(self.basic.reservation_rate)%"
    }
    var openingString: String {
        return "개봉일 : \(self.basic.date)"
    }
}

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
        return "평점 : \(user_rating) 예매순위 : \(reservation_grade) 예매율 : \(reservation_rate)"
    }
    var collectionViewInfoString: String {
        return "\(reservation_grade)위(\(user_rating)) / \(reservation_rate)%"
    }
    var openingString: String {
        return "개봉일 : \(date)"
    }
}

struct MovieDetail: Codable, Hashable {
    let audience: Int
    let grade: Int
    let actor: String
    let duration: Int
    let director: String
    let synopsis: String
    let genre: String
    let image: String
    let reservation_grade: Int
    let title: String
    let reservation_rate: Double
    let user_rating: Double
    let date: String
    let id: String
    
    var openingString: String {
        return "\(date)개봉"
    }
    var genreAndRunningTimeString: String {
        return "\(genre)/\(duration)분"
    }
    var reservationString: String {
        return "\(reservation_grade)위/\(reservation_rate)%"
    }
    var audienceString: String {
        var result: String = ""
        var audienceNumber: Int = audience
        while true {
            if ( audienceNumber / 1000 > 0 && result == "" ) {
                result = "\( String(audienceNumber%1000) )"
                audienceNumber /= 1000
            } else if audienceNumber / 1000 > 0 {
                result = "\( String(audienceNumber%1000) ),\( result )"
                audienceNumber /= 1000
            } else {
                result = "\( audienceNumber ),\( result )"
                break;
            }
        }
        return result
    }
}

struct CommentResponse: Codable {
    let movie_id: String
    let comments: [MovieComment]
}

struct MovieComment: Codable, Hashable {
    let rating: Double
    let timestamp: Double
    let writer: String
    let movie_id: String
    let contents: String
    
    var timeString: String {
        let date: Date = Date(timeIntervalSince1970: self.timestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        return dateFormatter.string(from: date)
    }
}
