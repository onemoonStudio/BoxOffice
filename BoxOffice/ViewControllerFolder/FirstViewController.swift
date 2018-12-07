//
//  ViewController.swift
//  BoxOffice
//
//  Created by Hyeontae on 06/12/2018.
//  Copyright © 2018 onemoon. All rights reserved.
//
// 예매율 큐레이션 개봉일
// TODO: cell 눌렀을때 age hightlighted
// TODO: MAge 설정 부분 따로 빼기


import UIKit

class FirstViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let cellIdentifier: String = "movieTableCell"
    var movieDatas: [MovieData] = []
    var sortingAlert: UIAlertController = UIAlertController()
    
    // 곧 사라질 예정
    var orderType: Int = 1
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let apiURL = URL(string: "http://connect-boxoffice.run.goorm.io/movies?order_type=\(orderType)") else { return }
        let session: URLSession = URLSession(configuration: .default)
        let dataTask: URLSessionDataTask = session.dataTask(with: apiURL) {
            (data: Data? , response: URLResponse? , error: Error? ) in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let data = data else { return }
            
            do{
                let apiResponse: APIResponse = try JSONDecoder().decode(APIResponse.self, from: data)
                self.movieDatas = apiResponse.movies
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch(let netErr) {
                print(netErr.localizedDescription)
            }
        }
        dataTask.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "예매율순"
        sortingAlert = UIAlertController(title: "정렬방식", message: "영화를 어떤 방식으로 정렬할까요?", preferredStyle: .actionSheet)
        let sortingByReservation = UIAlertAction(title: "예매율", style: .default, handler: { _ in
            self.changeSortingCriteria(criteria: 1)
        })
        let sortingByCuration = UIAlertAction(title: "큐레이션", style: .default, handler: { _ in
            self.changeSortingCriteria(criteria: 2)
        })
        let sortingByDate = UIAlertAction(title: "개봉일", style: .default, handler: { _ in
            self.changeSortingCriteria(criteria: 3)
        })
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        sortingAlert.addAction(sortingByReservation)
        sortingAlert.addAction(sortingByCuration)
        sortingAlert.addAction(sortingByDate)
        sortingAlert.addAction(cancelAction)
        
    }
    
    @IBAction func showSortingAlertSheet(_ sender: UIBarButtonItem) {
        present(sortingAlert, animated: true)
    }
    func changeSortingCriteria(criteria: Int) {
        switch criteria {
        case 1:
            self.movieDatas.sort(by: { $0.reservation_rate > $1.reservation_rate })
            self.navigationItem.title = "예매율순"
        case 2:
            self.movieDatas.sort(by: { $0.user_rating > $1.user_rating })
            self.navigationItem.title = "큐레이션"
        case 3:
            self.movieDatas.sort(by: { self.StringToDate($0.date) > self.StringToDate($1.date) })
            self.navigationItem.title = "개봉일순"
        default:
            self.navigationItem.title = "예매율순"
        }
        
        self.tableView.reloadData()
    }
    func StringToDate(_ dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date: Date = dateFormatter.date(from: dateString) else { return Date() }
        return date
    }
    

}

extension FirstViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: MovieDatasCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MovieDatasCell else { return UITableViewCell() }
        
        
        let movieData: MovieData = movieDatas[indexPath.row]
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
        cell.MInfo.text = movieData.infoString
        cell.MDate.text = movieData.openingString
        cell.Mimage.image = nil
        
        
        DispatchQueue.global().async {
            guard let imageURL = URL(string: movieData.thumb) else { return }
            guard let imageData: Data = try? Data(contentsOf: imageURL) else { return }

            DispatchQueue.main.async {
                if let index: IndexPath = tableView.indexPath(for: cell) {
                    if index.row == indexPath.row {
                        cell.Mimage.image = UIImage.init(data: imageData)
                    }
                }
            }
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieDatas.count
    }
}

extension FirstViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// 따로 빼는게 좋을까?
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat) {
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
    }
}
