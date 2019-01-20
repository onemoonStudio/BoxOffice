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
    var swipeDownGesture: UISwipeGestureRecognizer {
        let recognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeDownHandler))
        recognizer.direction = .down
        return recognizer
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        mainImageView.image = preparedImage
        scrollView.maximumZoomScale = 4.0
        scrollView.minimumZoomScale = 1.0
        scrollView.addGestureRecognizer(swipeDownGesture)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction func dismissButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func swipeDownHandler(_ sender: UISwipeGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension PictureFullScreenViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return mainImageView
    }
}
