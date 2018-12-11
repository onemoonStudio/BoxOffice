//
//  DetailViewController.swift
//  BoxOffice
//
//  Created by Hyeontae on 09/12/2018.
//  Copyright © 2018 onemoon. All rights reserved.
//
// 평점 별 표시
// 누적 관객수 , 표시
// 아래 comments 구현

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var mainTitleImage: UIImageView!
    @IBOutlet weak var mainDateLabel: UILabel!
    @IBOutlet weak var mainGenreLabel: UILabel!
    @IBOutlet weak var leftInfoReservationRateLabel: UILabel!
    @IBOutlet weak var midInfoUserRatingLabel: UILabel!
    @IBOutlet weak var mainStarsView: UIView!
    @IBOutlet weak var rightInfoAudienceLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var actorsLabel: UILabel!
    @IBOutlet weak var commentTable: UITableView!
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    let commentCellIdentifier: String = "commentCell"
    var movieId: String = ""
    var movieComments: [MovieComment] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.didRecieveDetailData(_:)), name: didReceiveMovieDetailData, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.didReceiveCommentsData(_:)), name: didRecieveCommentData, object: nil)
        loadingIndicator.startAnimating()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        detailRequest(movieId)
        detailCommentRequest(movieId)
    }
    
    @objc func didRecieveDetailData(_ noti: Notification) {
        DispatchQueue.main.async {
            guard let detailData = noti.userInfo?["apiResponse"] as? MovieDetail else { return }
            guard let imageData = noti.userInfo?["imageData"] as? Data else { return }
            
            self.navigationItem.title = detailData.title
            
            self.mainImageView.image = UIImage.init(data: imageData)
            self.mainTitleLabel.text = detailData.title
            // 0 12 15 19
            self.mainTitleImage.image = UIImage(named: "ic_\(detailData.grade)")
            self.mainDateLabel.text = detailData.openingString
            self.mainGenreLabel.text = detailData.genreAndRunningTimeString
            self.leftInfoReservationRateLabel.text = detailData.reservationString
            self.midInfoUserRatingLabel.text = String(detailData.user_rating)
            guard let mainStars = self.mainStarsView as? FiveStars else { return }
            mainStars.fillStarWithImage(detailData.user_rating)
            self.rightInfoAudienceLabel.text = detailData.audienceString
            // 이게 맞는 걸까?
            self.synopsisLabel.text = """
            \(detailData.synopsis)
            """
            self.directorLabel.text = detailData.director
            self.actorsLabel.text = detailData.actor
            self.loadingIndicator.stopAnimating()
        }
    }
    
    @objc func didReceiveCommentsData(_ noti: Notification) {
        DispatchQueue.main.async {
            guard let commentsData: [MovieComment] = noti.userInfo?["commentDatas"] as? [MovieComment] else { return }
            self.movieComments = commentsData
            self.commentTable.reloadData()
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieComments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: MovieCommentCell = tableView.dequeueReusableCell(withIdentifier: commentCellIdentifier, for: indexPath) as? MovieCommentCell else { return UITableViewCell() }
        let commentData: MovieComment = movieComments[indexPath.row]
        cell.writer.text = commentData.writer
        cell.timeString.text = commentData.timeString
        cell.comment.text = commentData.contents
//        cell.fillStarWithImage(commentData.rating)
        cell.fillStarWithImageInt(commentData.rating)
        
//        guard let comStars = cell.starImages as? FiveStars else { return }
//        mainStars.fillStarWithImage(detailData.user_rating)
        
        return cell
        
    }
    
}

extension DetailViewController: UITabBarDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
