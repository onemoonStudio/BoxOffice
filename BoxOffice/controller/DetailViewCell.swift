//
//  DetailViewCell.swift
//  BoxOffice
//
//  Created by Hyeontae on 16/12/2018.
//  Copyright © 2018 onemoon. All rights reserved.
//

import UIKit

class FiveStars: UIView {
    // nib으로 빼서 이미지를 연결할 필요 없이 그냥 만든다
    // nib -> view 만 하는 스토리보드?
    @IBOutlet var starImages: [UIImageView]!
    
    func fillStarWithImage(_ inputRating: Double) {
        let preImageName: String = "ic_star_large_"
        let halfRating: Double = inputRating/2.0
        
        for order in 0...4 {
            let rating = halfRating - Double(order)
            if rating < 0.5 {
                starImages[order].image = UIImage(named: "\(preImageName)empty")
            } else if 0.5 <= rating && rating < 1 {
                starImages[order].image = UIImage(named: "\(preImageName)half")
            } else {
                starImages[order].image = UIImage(named: "\(preImageName)full")
            }

        }
        
        
    }
}

class MovieDetailInformationCell: UITableViewCell {
    @IBOutlet weak var mainPosterImageView: UIImageView!
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var mainGradeImage: UIImageView!
    @IBOutlet weak var mainDateLabel: UILabel!
    @IBOutlet weak var mainGenreLabel: UILabel!
    @IBOutlet weak var leftInfoReservationRateLabel: UILabel!
    @IBOutlet weak var midInfoUserRatingLabel: UILabel!
    @IBOutlet weak var mainStarsView: UIView!
    @IBOutlet weak var rightInfoAudienceLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var actorsLabel: UILabel!
    
    func configure(_ data: MovieDetail ,imageData: Data) {
        let movieDetailData = data
        mainPosterImageView.image = UIImage(data: imageData)
        mainTitleLabel.text = movieDetailData.title
        mainGradeImage.image = UIImage(named: "ic_\(movieDetailData.grade)")
        mainDateLabel.text = movieDetailData.openingString
        mainGenreLabel.text = movieDetailData.genreAndRunningTimeString
        leftInfoReservationRateLabel.text = movieDetailData.reservationString
        midInfoUserRatingLabel.text = String(movieDetailData.user_rating)
        rightInfoAudienceLabel.text = movieDetailData.audienceString
        synopsisLabel.text = movieDetailData.synopsis
        directorLabel.text = movieDetailData.director
        actorsLabel.text = movieDetailData.actor
    }
}

class MovieCommentCell: UITableViewCell {
    @IBOutlet weak var writer: UILabel!
//    @IBOutlet var starImages: [UIImageView]!
    @IBOutlet var starImages: FiveStars!
    @IBOutlet weak var timeString: UILabel!
    @IBOutlet weak var comment: UILabel!
    
//    func fillStarWithImageInt(_ inputRating: Double) {
//        let preImageName: String = "ic_star_large_"
//        for order in 0...4 {
//            let temp: Int = Int(inputRating) - order*2
//            if temp > 1 {
//                self.starImages[order].image = UIImage(named: "\(preImageName)full")
//            } else if temp == 1 {
//                self.starImages[order].image = UIImage(named: "\(preImageName)half")
//            } else {
//                self.starImages[order].image = UIImage(named: "\(preImageName)empty")
//            }
//        }
//    }
    
    func configure(_ data: MovieComment) {
        let commentData = data
        writer.text = commentData.writer
        timeString.text = commentData.timeString
        comment.text = commentData.contents
//        fillStarWithImageInt(commentData.rating)
        starImages.fillStarWithImage(commentData.rating)

    }
}
