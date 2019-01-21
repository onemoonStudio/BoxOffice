//
//  MovieCollectionViewController.swift
//  BoxOffice
//
//  Created by Hyeontae on 06/12/2018.
//  Copyright © 2018 onemoon. All rights reserved.
//

import UIKit

class MovieCollectionViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    private let cellIdentifider: String = "movieCollectionViewCell"
    private let refreshControl: UIRefreshControl = UIRefreshControl()
    private var networkErrorAlert: UIAlertController = UIAlertController()
    private var sortingAlert: UIAlertController = UIAlertController()
    private var halfWidth: CGFloat = UIScreen.main.bounds.width / 2.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addObserver()
        setNetworkErrorAlert()
        setNavigationBarTitle()

        refreshControl.addTarget(self, action: #selector(refreshHandler(_:)), for: .valueChanged)
        collectionView.addSubview(refreshControl)
        
        setCollectionViewFlowLayout()
    }
    
    fileprivate func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.mainNetworkError(_:)), name: .moviesDataRequestError, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.orderingData(_:)), name: .changeDataOrderNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateData(_:)), name: .updateDataNotification, object: nil)
    }
    
    fileprivate func setCollectionViewFlowLayout() {
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.itemSize = CGSize(width: halfWidth - 10, height: 320)
        self.collectionView.collectionViewLayout = flowLayout
    }
    
    fileprivate func setNetworkErrorAlert() {
        networkErrorAlert = UIAlertController(title: "네트워크 에러", message: "네트워크를 확인하신 뒤 다시 시도해주세요", preferredStyle: .alert)
        networkErrorAlert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
    }
    
    fileprivate func setNavigationBarTitle() {
        switch Manager.sharedInstance.nowOrderType {
        case 1:
            self.navigationItem.title = "예매율순"
        case 2:
            self.navigationItem.title = "큐레이션"
        case 3:
            self.navigationItem.title = "개봉일순"
        default:
            self.navigationItem.title = "예매율순"
        }

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
        Manager.sharedInstance.requestData(initRequest: false)
    }
    @objc func updateData(_ noti: Notification){
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    @IBAction func showSortingAlertSheet(_ sender: UIBarButtonItem) {
        presentActionSheet { [weak self] (orderType) in
            guard let self = self else { return }
            self.loadingIndicator.startAnimating()
            Manager.sharedInstance.orderingData(orderType)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailView: DetailViewController = segue.destination as? DetailViewController else { return }
        guard let cell = sender as? MovieCollectionDataCell else { return }
        detailView.movieId = cell.movieId.text!
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

extension MovieCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Manager.sharedInstance.movieData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: MovieCollectionDataCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifider, for: indexPath) as? MovieCollectionDataCell  else { return UICollectionViewCell() }
        
        let movieImageData: Data = Manager.sharedInstance.movieData[indexPath.item].imageData
        
        cell.configure(indexPath.item)
        
        DispatchQueue.main.async {
            cell.movieImage.image = UIImage(data: movieImageData)
        }
        
        return cell
    }
    
    
}
extension MovieCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
