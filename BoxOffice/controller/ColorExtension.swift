//
//  colorExtension.swift
//  BoxOffice
//
//  Created by Hyeontae on 16/12/2018.
//  Copyright © 2018 onemoon. All rights reserved.
//

import UIKit

extension UIColor {
    @nonobjc class var allAgeGreen: UIColor {
        return UIColor(red: 0x78, green: 0xB3, blue: 0x7E, alpha: 1.0)
    }
    @nonobjc class var twelveBlue: UIColor {
        return UIColor(red: 0x50, green: 0xA8, blue: 0xF0, alpha: 1.0)
    }
    @nonobjc class var fifteenOrange: UIColor {
        return UIColor(red: 0xEF, green: 0x95, blue: 0x32, alpha: 1.0)
    }
    @nonobjc class var nineteenRed: UIColor {
        return UIColor(red: 0xE5, green: 0x3D, blue: 0x44, alpha: 1.0)
    }
    convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat) {
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
    }
}
