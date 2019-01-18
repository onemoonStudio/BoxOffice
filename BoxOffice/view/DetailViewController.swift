//
//  DetailViewController.swift
//  BoxOffice
//
//  Created by Hyeontae on 09/12/2018.
//  Copyright © 2018 onemoon. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var detailTable: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    let movieDetailCellIndicator: String = "movieDetailCell"
    let commentCellIdentifier: String = "commentCell"
    var movieId: String = ""
    var movieDetailData: MovieDetail = MovieDetail()
    var moviePosterData: Data = Data()
    var movieComments: [MovieComment] = []
    var networkErrorAlert: UIAlertController = UIAlertController()
    var commentNetworkErrorAlert: UIAlertController = UIAlertController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didRecieveDetailData), name: .didReceiveMovieDetailData, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveCommentsData), name: .didRecieveCommentData, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveNetworkError), name: .detailNetworkError, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.didReceiveCommentNetworkError(_:)), name: .detailCommentsNetworkError, object: nil)
        loadingIndicator.startAnimating()
        
        networkErrorAlert = UIAlertController(title: "네트워크 에러", message: "네트워크를 확인하신 뒤 다시 시도해주세요", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: { _ in
            self.loadingIndicator.stopAnimating()
            self.networkErrorCallback()
        })
        networkErrorAlert.addAction(okAction)
        
        commentNetworkErrorAlert = UIAlertController(title: "네트워크 에러", message: "한줄평을 불러올 수 없습니다.", preferredStyle: .alert)
        let commentOkAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        commentNetworkErrorAlert.addAction(commentOkAction)
        detailRequest(movieId)
        detailCommentRequest(movieId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        detailRequest(movieId)
//        detailCommentRequest(movieId)
    }
    
    @objc func didRecieveDetailData(_ noti: Notification) {
        DispatchQueue.main.async {
            guard let detailData = noti.userInfo?["apiResponse"] as? MovieDetail else { return }
            guard let imageData = noti.userInfo?["imageData"] as? Data else { return }
            
            self.movieDetailData = detailData
            self.moviePosterData = imageData
            self.detailTable.reloadSections(IndexSet(0...0), with: .automatic)
            self.loadingIndicator.stopAnimating()
        }
    }
    
    @objc func didReceiveCommentsData(_ noti: Notification) {
        DispatchQueue.main.async {
            guard let commentsData: [MovieComment] = noti.userInfo?["commentDatas"] as? [MovieComment] else { return }
            self.movieComments = commentsData
            self.detailTable.reloadSections(IndexSet(1...1), with: .automatic)
        }
    }
    
    @objc func didReceiveNetworkError(_ noti: Notification) {
        DispatchQueue.main.async {
            self.present(self.networkErrorAlert, animated: true)
        }
    }
    
    @objc func didReceiveCommentNetworkError(_ noti: Notification) {
        DispatchQueue.main.async { [weak self] in
            if let self = self {
                self.present(self.commentNetworkErrorAlert, animated: true)
            }
        }
    }
    
    func networkErrorCallback() {
        self.networkErrorAlert.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func imageFullScreen(_ sender: UITapGestureRecognizer) {
        let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let pictureFullScreenVC: PictureFullScreenViewController = mainStoryBoard.instantiateViewController(withIdentifier: "PictureFullScreen") as? PictureFullScreenViewController else { return }
        guard let prepareImage: UIImage = UIImage(data: moviePosterData) else { return }
        pictureFullScreenVC.preparedImage = prepareImage
//        show(pictureFullScreenVC, sender: nil)
        present(pictureFullScreenVC, animated: true)
        
    }
    
    
}

extension DetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return movieComments.count
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            // detail Information
            guard let movieDetailCell: MovieDetailInformationCell = tableView.dequeueReusableCell(withIdentifier: movieDetailCellIndicator, for: indexPath) as? MovieDetailInformationCell else { return UITableViewCell() }            
            
            movieDetailCell.configure(self.movieDetailData , imageData: self.moviePosterData)
            guard let mainStars = movieDetailCell.mainStarsView as? FiveStars else { return UITableViewCell() }
            mainStars.fillStarWithImage(movieDetailData.user_rating)
            
            let imageTapGesture = UITapGestureRecognizer(target: self, action: #selector(imageFullScreen(_:)))
            imageTapGesture.numberOfTapsRequired = 1
            movieDetailCell.mainPosterImageView.addGestureRecognizer(imageTapGesture)

            movieDetailCell.selectionStyle = .none
            return movieDetailCell
        } else {
            // comments
            tableView.separatorColor = UIColor.white
            guard let commentCell: MovieCommentCell = tableView.dequeueReusableCell(withIdentifier: self.commentCellIdentifier, for: indexPath) as? MovieCommentCell else { return UITableViewCell() }
            let commentData: MovieComment = movieComments[indexPath.row]
            commentCell.configure(commentData)
            
            commentCell.selectionStyle = .none
            return commentCell
        }
    }
    
}
