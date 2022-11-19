//
//  NewsDetailsViewController.swift
//  FiO
//
//  Created by admin on 1.08.2022.
//

import UIKit

class NewsDetailsViewController: UIViewController{
    
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsBody: UILabel!
    
    var news:Result?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsTitle.text = news?.title
        newsBody.text = news?.body
        newsImage.kf.setImage(with: URL(string: news!.image ?? ""),
                              placeholder: UIImage(named: "no-image"))
        
    }
    
}
