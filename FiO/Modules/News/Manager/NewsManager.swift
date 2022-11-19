//
//  NewsManager.swift
//  FiO
//
//  Created by admin on 30.07.2022.
//

import Foundation
protocol NewsDelegate{
    func updateNews(_ news: [Result])
}
class NewsManager{
    
    var delegate: NewsDelegate?
    
    func performRequest(){
        //You can get a free apiKey from the link below in order to use the app
        
        let apiKey = "" //Write your apiKey here
        let urlString = "https://newsapi.ai/api/v1/article/getArticles?query=%7B%22%24query%22%3A%7B%22%24and%22%3A%5B%7B%22%24and%22%3A%5B%7B%22conceptUri%22%3A%22http%3A%2F%2Fen.wikipedia.org%2Fwiki%2FPolitics%22%7D%2C%7B%22conceptUri%22%3A%22http%3A%2F%2Fen.wikipedia.org%2Fwiki%2FSport%22%7D%2C%7B%22conceptUri%22%3A%22http%3A%2F%2Fen.wikipedia.org%2Fwiki%2FInformation_technology%22%7D%5D%7D%2C%7B%22%24or%22%3A%5B%7B%22lang%22%3A%22eng%22%7D%2C%7B%22lang%22%3A%22tur%22%7D%5D%7D%5D%7D%2C%22%24filter%22%3A%7B%22forceMaxDataTimeWindow%22%3A%2231%22%2C%22dataType%22%3A%5B%22news%22%5D%7D%7D&resultType=articles&articlesSortBy=date&articlesCount=100&articleBodyLen=-1&apiKey=\(apiKey)"

        if let url = URL(string: urlString){
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: request) { data, response, err in
                if err != nil{
                    print(err!)
                }
                if let safeData = data{
                    if let parsedData = self.parse(safeData){
                        self.delegate?.updateNews(parsedData.articles.results)
                    }
                }
            }
            task.resume()
        }
    }
    
    
    func parse(_ data:Data) -> NewsModel?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(NewsModel.self, from: data)
            return decodedData
        }catch{
            print(error)
        }
        return nil
    }
}
