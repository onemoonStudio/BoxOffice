//
//  ViewController.swift
//  BoxOffice
//
//  Created by Hyeontae on 06/12/2018.
//  Copyright © 2018 onemoon. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    let cellIdentifier: String = "movieTableCell"
    var movieDatas: [MovieData] = []
    var orderType: Int = 1
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.estimatedRowHeight = 140
        // 이게 없으면 망가짐... 왜지?
        
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
                //                self.movieDatas = try JSONDecoder().decode([MovieData].self, from: data)
                self.movieDatas = apiResponse.movies
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch(let netErr) {
                print(netErr.localizedDescription)
            }
        }
        
        dataTask.resume()
        
//        self.tableView.rowHeight = UITableView.automaticDimension
        

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        print("hear")
        // Do any additional setup after loading the view, typically from a nib.
    }

}

extension FirstViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: MovieDatasCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MovieDatasCell else { return UITableViewCell() }
        
        
        let movieData: MovieData = movieDatas[indexPath.row]
//        cell.MTitle.text = movieData.title
//        cell.MAge.text = String(movieData.grade)
//        cell.MInfo.text = movieData.infoString
//        cell.MOpening.text = movieData.openingString
//        cell.Mimage.image = nil
        
        
//        DispatchQueue.global().async {
//            guard let imageURL = URL(string: movieData.thumb) else { return }
//            guard let imageData: Data = try? Data(contentsOf: imageURL) else { return }
//
//            DispatchQueue.main.async {
//                if let index: IndexPath = tableView.indexPath(for: cell) {
//                    if index.row == indexPath.row {
//                        cell.Mimage.image = UIImage.init(data: imageData)
//                    }
//                }
//            }
//        }
        
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
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let height: CGFloat = CGFloat(bitPattern: 120)
//        return height
//    }
}

