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
    
}

class MovieCollectionDataCell: UICollectionViewCell {
    @IBOutlet weak var MImage: UIImageView!
    @IBOutlet weak var MTitle: UILabel!
    @IBOutlet weak var MAge: UILabel!
    @IBOutlet weak var MInfo: UILabel!
    @IBOutlet weak var MDate: UILabel!
    
}

// hexcode Color
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat) {
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
    }
}
