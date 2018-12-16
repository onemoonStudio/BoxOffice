//
//  PictureFullScreenViewController.swift
//  BoxOffice
//
//  Created by Hyeontae on 13/12/2018.
//  Copyright © 2018 onemoon. All rights reserved.
//

import UIKit

class PictureFullScreenViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mainImageView: UIImageView!
    var preparedImage: UIImage = UIImage()
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        mainImageView.image = preparedImage
        scrollView.maximumZoomScale = 4.0
        scrollView.minimumZoomScale = 1.0
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction func swipeGestureForPopViewController(_ sender: UISwipeGestureRecognizer) {
        navigationController?.popViewController(animated: true)
    }
    
}

extension PictureFullScreenViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return mainImageView
    }
}
