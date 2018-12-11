//
//  SecondViewController.swift
//  BoxOffice
//
//  Created by Hyeontae on 06/12/2018.
//  Copyright © 2018 onemoon. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    let cellIdentifider: String = "movieCollectionViewCell"
    var sortingAlert: UIAlertController = UIAlertController()
    var halfWidth: CGFloat = UIScreen.main.bounds.width / 2.0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        NotificationCenter.default.addObserver(self, selector: #selector(self.didReceiveData(_:)), name: didReceiveDataNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.orderingData(_:)), name: changeDataOrderNotification, object: nil)
//        loadingIndicator.startAnimating()
        
        self.navigationItem.title = "예매율순"
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
        
        
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets.init(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.itemSize = CGSize(width: halfWidth - 10, height: 320)
        self.collectionView.collectionViewLayout = flowLayout
    }
    
//    @objc func didReceiveData(_ noti: Notification) {
//        DispatchQueue.main.async {
//            self.loadingIndicator.stopAnimating()
//            self.collectionView.reloadData()
//        }
//    }
    @objc func orderingData(_ noti: Notification){
        DispatchQueue.main.async {
            guard let newTitle: String = noti.userInfo?["navigationBarTitle"] as? String else { return }
            self.navigationItem.title = newTitle
            self.loadingIndicator.stopAnimating()
            self.collectionView.reloadData()
        }
    }
    
    @IBAction func showSortingAlertSheet(_ sender: UIBarButtonItem) {
        present(sortingAlert, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailView: DetailViewController = segue.destination as? DetailViewController else { return }
        guard let cell = sender as? MovieCollectionDataCell else { return }
        detailView.movieId = cell.MId.text!
    }
    

    
}

extension SecondViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SingletonData.sharedInstance.movieDatas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: MovieCollectionDataCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifider, for: indexPath) as? MovieCollectionDataCell  else { return UICollectionViewCell() }
        
        let movieData: MovieData = SingletonData.sharedInstance.movieDatas[indexPath.item].basic
        let movieImageData: Data = SingletonData.sharedInstance.movieDatas[indexPath.item].imageData
        
        cell.MTitle.text = movieData.title
        var ageLabelColor: UIColor
        switch movieData.grade {
        case 0:
            //            35FF4E
            ageLabelColor = UIColor.init(red: 0x78, green: 0xB3, blue: 0x7E, alpha: 1.0)
        case 12:
            // 50A8F0
            ageLabelColor = UIColor.init(red: 0x50, green: 0xA8, blue: 0xF0, alpha: 1.0)
        case 15:
            // EF9532
            ageLabelColor = UIColor.init(red: 0xEF, green: 0x95, blue: 0x32, alpha: 1.0)
        case 19:
            // E53D44
            ageLabelColor = UIColor.init(red: 0xE5, green: 0x3D, blue: 0x44, alpha: 1.0)
        default:
            ageLabelColor = UIColor.init(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
        cell.MAge.text = movieData.grade == 0 ? "전체" : String(movieData.grade)
        cell.MAge.backgroundColor = ageLabelColor
        cell.MAge.layer.masksToBounds = true
        cell.MAge.layer.cornerRadius = 15.0
        cell.MAge.textColor = UIColor.white
        //        cell.MAge.highlightedTextColor = UIColor.white
        // highlighted 된거 물어보기
        cell.MInfo.text = movieData.collectionViewInfoString
        cell.MDate.text = movieData.date
        cell.MImage.image = nil
        cell.MId.text = movieData.id
        
        DispatchQueue.main.async {
            cell.MImage.image = UIImage.init(data: movieImageData)
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
extension SecondViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
}
extension SecondViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: halfWidth-10, height: 320)
//    }
}


