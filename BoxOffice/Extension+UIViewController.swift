//
//  Extension+UIViewController.swift
//  BoxOffice
//
//  Created by ParkSungJoon on 20/01/2019.
//  Copyright © 2019 onemoon. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func presentActionSheet(completion: @escaping (_ orderType: Int) -> ()) {
        let optionMenu = UIAlertController(title: "정렬방식", message: "영화를 어떤 방식으로 정렬할까요?", preferredStyle: .actionSheet)
        
        let sortReservationAction = UIAlertAction(
            title: "예매율",
            style: .default,
            handler: { (alert: UIAlertAction!) -> Void in
                completion(1)
        })
        
        let sortCurationAction = UIAlertAction(
            title: "큐레이션",
            style: .default,
            handler: { (alert: UIAlertAction!) -> Void in
                completion(2)
        })
        let sortDateAction = UIAlertAction(
            title: "개봉일",
            style: .default,
            handler: { (alert: UIAlertAction!) -> Void in
                completion(3)
        })
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        optionMenu.addAction(sortReservationAction)
        optionMenu.addAction(sortCurationAction)
        optionMenu.addAction(sortDateAction)
        optionMenu.addAction(cancelAction)
        present(optionMenu, animated: true, completion: nil)
    }
}
