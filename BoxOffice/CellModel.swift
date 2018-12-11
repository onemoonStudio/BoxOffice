//
//  CellModel.swift
//  BoxOffice
//
//  Created by Hyeontae on 06/12/2018.
//  Copyright © 2018 onemoon. All rights reserved.
//

import UIKit

// MARK: ARC 생각해보기 그리고 동일한 셀렉션 뷰를 또 만들어야 하나?
class MovieDatasCell: UITableViewCell{
    
    @IBOutlet weak var MImage: UIImageView!
    @IBOutlet weak var MTitle: UILabel!
    @IBOutlet weak var MAge: UILabel!
    @IBOutlet weak var MInfo: UILabel!
    @IBOutlet weak var MDate: UILabel!
    @IBOutlet weak var MId: UILabel!
    
}

class MovieCollectionDataCell: UICollectionViewCell {
    @IBOutlet weak var MImage: UIImageView!
    @IBOutlet weak var MTitle: UILabel!
    @IBOutlet weak var MAge: UILabel!
    @IBOutlet weak var MInfo: UILabel!
    @IBOutlet weak var MDate: UILabel!
    @IBOutlet weak var MId: UILabel!
}

class FiveStars: UIView {
    @IBOutlet var starImages: [UIImageView]!
    
    func fillStarWithImage(_ inputRating: Double) {
        let preImageName: String = "ic_star_large_"
        let halfRating: Double = inputRating/2.0
        for order in 0...4 {
            let rating = halfRating - Double(order)
            if ( rating < 0.5 ){
                self.starImages[order].image = UIImage(named: "\(preImageName)empty")
            } else if ( 0.5 <= rating && rating < 1 ) {
                self.starImages[order].image = UIImage(named: "\(preImageName)half")
            } else {
                self.starImages[order].image = UIImage(named: "\(preImageName)full")
            }
        }
        
    }
}

class MovieCommentCell: UITableViewCell {
    @IBOutlet weak var writer: UILabel!
    @IBOutlet var starImages: [UIImageView]!
    @IBOutlet weak var timeString: UILabel!
    @IBOutlet weak var comment: UILabel!
    
    func fillStarWithImageInt(_ inputRating: Int) {
        let preImageName: String = "ic_star_large_"
        for order in 0...4 {
            let temp: Int = inputRating - order*2
            if temp > 1 {
                self.starImages[order].image = UIImage(named: "\(preImageName)full")
            } else if temp == 1 {
                self.starImages[order].image = UIImage(named: "\(preImageName)half")
            } else {
                self.starImages[order].image = UIImage(named: "\(preImageName)empty")
            }
//            if (  < 0.5 ){
//                self.starImages[order].image = UIImage(named: "\(preImageName)empty")
//            } else if ( 0.5 <= rating && rating < 1 ) {
//                self.starImages[order].image = UIImage(named: "\(preImageName)half")
//            } else {
//                self.starImages[order].image = UIImage(named: "\(preImageName)full")
//            }
        }
    }
}

// hexcode Color
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat) {
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
    }
}
