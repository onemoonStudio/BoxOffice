//
//  MovieTableViewController.swift
//  BoxOffice
//
//  Created by Hyeontae on 06/12/2018.
//  Copyright © 2018 onemoon. All rights reserved.
//

import UIKit

class MovieTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    let cellIdentifier: String = "movieTableCell"
    let refreshControl: UIRefreshControl = UIRefreshControl()
    var networkErrorAlert: UIAlertController = UIAlertController()
    var sortingAlert: UIAlertController = UIAlertController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addObserver()
        loadingIndicator.startAnimating()
        
        networkErrorAlert = UIAlertController(title: "네트워크 에러", message: "네트워크를 확인하신 뒤 다시 시도해주세요", preferredStyle: .alert)
        networkErrorAlert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        
        self.navigationItem.title = "예매율순"
        sortingAlert = UIAlertController(title: "정렬방식", message: "영화를 어떤 방식으로 정렬할까요?", preferredStyle: .actionSheet)
        let sortingByReservation = UIAlertAction(title: "예매율", style: .default, handler: { _ in
            self.loadingIndicator.startAnimating()
            MovieDatas.sharedInstance.orderingData(1)
        })
        let sortingByCuration = UIAlertAction(title: "큐레이션", style: .default, handler: { _ in
            self.loadingIndicator.startAnimating()
            MovieDatas.sharedInstance.orderingData(2)
        })
        let sortingByDate = UIAlertAction(title: "개봉일", style: .default, handler: { _ in
            self.loadingIndicator.startAnimating()
            MovieDatas.sharedInstance.orderingData(3)
        })
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        sortingAlert.addAction(sortingByReservation)
        sortingAlert.addAction(sortingByCuration)
        sortingAlert.addAction(sortingByDate)
        sortingAlert.addAction(cancelAction)
        
        refreshControl.addTarget(self, action: #selector(refreshHandler(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
    }
    
    fileprivate func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.mainNetworkError(_:)), name: .moviesDataRequestError, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.didReceiveData(_:)), name: .didReceiveDataNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.orderingData(_:)), name: .changeDataOrderNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateData(_:)), name: .updateDataNotification, object: nil)
    }
    
    @objc func mainNetworkError(_ noti: Notification) {
        present(networkErrorAlert,animated: true)
        DispatchQueue.main.async {
            self.loadingIndicator.stopAnimating()
        }
    }
    
    @objc func didReceiveData(_ noti: Notification) {
        DispatchQueue.main.async {
            self.loadingIndicator.stopAnimating()
            self.tableView.reloadData()
        }
    }
    @objc func orderingData(_ noti: Notification){
        DispatchQueue.main.async {
            guard let newTitle: String = noti.userInfo?["navigationBarTitle"] as? String else { return }
            self.navigationItem.title = newTitle
            self.loadingIndicator.stopAnimating()
            self.tableView.reloadData()
        }
    }
    @objc func refreshHandler(_ refreshControl: UIRefreshControl) {
        MovieDatas.sharedInstance.requestData(initRequest: false)
    }
    @objc func updateData(_ noti: Notification){
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    @IBAction func showSortingAlertSheet(_ sender: UIBarButtonItem) {
        present(sortingAlert, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailView: DetailViewController = segue.destination as? DetailViewController else { return }
        guard let cell = sender as? MovieDatasCell else { return }
        detailView.movieId = cell.movieId.text!
    }

}

extension MovieTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: MovieDatasCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as?  MovieDatasCell else { return UITableViewCell() }
        let movieImagedata: Data = MovieDatas.sharedInstance.movieData[indexPath.row].imageData
        
        cell.configure(indexPath.row)
        DispatchQueue.main.async {
            cell.movieImage.image = UIImage(data: movieImagedata)
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MovieDatas.sharedInstance.movieData.count
    }
    
}

extension MovieTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
