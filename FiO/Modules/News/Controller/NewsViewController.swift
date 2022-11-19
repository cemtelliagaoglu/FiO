//
//  NewsViewController.swift
//  FiO
//
//  Created by admin on 30.07.2022.
//

import UIKit
import Kingfisher

class NewsViewController:UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var index:Int = 0
    let newsManager = NewsManager()
    var news: [Result]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier: "Cell")
        tableView.dataSource = self
        tableView.delegate = self
        newsManager.delegate = self
        newsManager.performRequest()
        
    }
}

//MARK: - NewsDelegate
extension NewsViewController:NewsDelegate{
    func updateNews(_ news: [Result]) {
        self.news = news
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
}

//MARK: - TableView Methods
extension NewsViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return news?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! NewsCell
        if let news = news?[indexPath.row]{
            cell.newsTitle.text = news.title
            cell.newsDetails.text = news.body
            
            
            DispatchQueue.main.async {
                cell.newsImage.kf.setImage(with: URL(string: news.image ?? ""),
                                           for: .normal,
                                           placeholder: UIImage(named: "no-image"))
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        performSegue(withIdentifier: "goToNewsDetails", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! NewsDetailsViewController
        destinationVC.news = news?[index]
    }
}
