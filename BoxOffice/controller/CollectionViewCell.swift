//
//  CollectionViewCell.swift
//  BoxOffice
//
//  Created by Hyeontae on 16/12/2018.
//  Copyright © 2018 onemoon. All rights reserved.
//

import UIKit

class MovieCollectionDataCell: UICollectionViewCell {
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieAge: UILabel!
    @IBOutlet weak var movieInfo: UILabel!
    @IBOutlet weak var movieDate: UILabel!
    @IBOutlet weak var movieId: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUISetting()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        movieImage.image = nil
    }
    
    func configure(_ index: Int) {
        let movieData: MovieData = MovieDatas.sharedInstance.movieData[index].basic
        movieTitle.text = movieData.title
        movieAge.text = movieData.grade == 0 ? "전체" : String(movieData.grade)
         movieAge.backgroundColor = colorForAge(movieData.grade)
        movieInfo.text = movieData.collectionViewInfoString
        movieDate.text = movieData.date
        movieId.text = movieData.id
    }
    
    private func setUISetting() {
        movieAge.layer.masksToBounds = true
        movieAge.layer.cornerRadius = 15.0
        movieAge.textColor = UIColor.white
    }
    
    private func colorForAge(_ age: Int) -> UIColor {
        var ageColor: UIColor
        switch age {
        case 0:
            ageColor = UIColor.allAgeGreen
        case 12:
            ageColor = UIColor.twelveBlue
        case 15:
            ageColor = UIColor.fifteenOrange
        case 19:
            ageColor = UIColor.nineteenRed
        default:
            ageColor = UIColor.allAgeGreen
        }
        return ageColor
    }
}
