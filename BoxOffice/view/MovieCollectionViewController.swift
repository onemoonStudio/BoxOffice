//
//  SecondViewController.swift
//  BoxOffice
//
//  Created by Hyeontae on 06/12/2018.
//  Copyright © 2018 onemoon. All rights reserved.
//

import UIKit

class MovieCollectionViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    let cellIdentifider: String = "movieCollectionViewCell"
    let refreshControl: UIRefreshControl = UIRefreshControl()
    var networkErrorAlert: UIAlertController = UIAlertController()
    var sortingAlert: UIAlertController = UIAlertController()
    var halfWidth: CGFloat = UIScreen.main.bounds.width / 2.0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.mainNetworkError(_:)), name: moviesDataRequestError, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.orderingData(_:)), name: changeDataOrderNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateData(_:)), name: updateDataNotification, object: nil)
        
        networkErrorAlert = UIAlertController(title: "네트워크 에러", message: "네트워크를 확인하신 뒤 다시 시도해주세요", preferredStyle: .alert)
        networkErrorAlert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        
        switch SingletonData.sharedInstance.nowOrderType {
        case 1:
            self.navigationItem.title = "예매율순"
        case 2:
            self.navigationItem.title = "큐레이션"
        case 3:
            self.navigationItem.title = "개봉일순"
        default:
            self.navigationItem.title = "예매율순"
        }
        
        sortingAlert = UIAlertController(title: "정렬방식", message: "영화를 어떤 방식으로 정렬할까요?", preferredStyle: .actionSheet)
        let sortingByReservation = UIAlertAction(title: "예매율", style: .default, handler: { _ in
            self.loadingIndicator.startAnimating()
            SingletonData.sharedInstance.orderingData(1)
        })
        let sortingByCuration = UIAlertAction(title: "큐레이션", style: .default, handler: { _ in
            self.loadingIndicator.startAnimating()
            SingletonData.sharedInstance.orderingData(2)
        })
        let sortingByDate = UIAlertAction(title: "개봉일", style: .default, handler: { _ in
            self.loadingIndicator.startAnimating()
            SingletonData.sharedInstance.orderingData(3)
        })
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        sortingAlert.addAction(sortingByReservation)
        sortingAlert.addAction(sortingByCuration)
        sortingAlert.addAction(sortingByDate)
        sortingAlert.addAction(cancelAction)
        
        refreshControl.addTarget(self, action: #selector(refreshHandler(_:)), for: .valueChanged)
        collectionView.addSubview(refreshControl)
        
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets.init(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.itemSize = CGSize(width: halfWidth - 10, height: 320)
        self.collectionView.collectionViewLayout = flowLayout
    }
    
    @objc func mainNetworkError(_ noti: Notification) {
        present(networkErrorAlert,animated: true)
        DispatchQueue.main.async {
            self.loadingIndicator.stopAnimating()
        }
    }
    
    @objc func orderingData(_ noti: Notification){
        DispatchQueue.main.async {
            guard let newTitle: String = noti.userInfo?["navigationBarTitle"] as? String else { return }
            self.navigationItem.title = newTitle
            self.loadingIndicator.stopAnimating()
            self.collectionView.reloadData()
        }
    }
    @objc func refreshHandler(_ refreshControl: UIRefreshControl) {
        SingletonData.sharedInstance.requestData(initRequest: false)
    }
    @objc func updateData(_ noti: Notification){
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    @IBAction func showSortingAlertSheet(_ sender: UIBarButtonItem) {
        present(sortingAlert, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailView: DetailViewController = segue.destination as? DetailViewController else { return }
        guard let cell = sender as? MovieCollectionDataCell else { return }
        detailView.movieId = cell.movieId.text!
    }
    

    
}

extension MovieCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SingletonData.sharedInstance.movieDatas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: MovieCollectionDataCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifider, for: indexPath) as? MovieCollectionDataCell  else { return UICollectionViewCell() }
        
        let movieData: MovieData = SingletonData.sharedInstance.movieDatas[indexPath.item].basic
        let movieImageData: Data = SingletonData.sharedInstance.movieDatas[indexPath.item].imageData
        
        cell.movieTitle.text = movieData.title
        cell.movieAge.text = movieData.grade == 0 ? "전체" : String(movieData.grade)
        cell.setColorForAge(movieData.grade)
        cell.movieAge.layer.masksToBounds = true
        cell.movieAge.layer.cornerRadius = 15.0
        cell.movieAge.textColor = UIColor.white
        cell.movieInfo.text = movieData.collectionViewInfoString
        cell.movieDate.text = movieData.date
        cell.movieImage.image = nil
        cell.movieId.text = movieData.id
        
        DispatchQueue.main.async {
            cell.movieImage.image = UIImage.init(data: movieImageData)
            // 왜 안되는 걸까? -> 아래 해결 하기 순서에 맞춘 데이터
//            if let index: IndexPath = collectionView.indexPath(for: cell) {
//                if index.item == indexPath.item {
//                    cell.MImage.image = UIImage.init(data: movieImageData)
//                }
//            }
        }
        
        return cell
    }
    
    
}
extension MovieCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
