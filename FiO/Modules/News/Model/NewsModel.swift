//
//  NewsModel.swift
//  FiO
//
//  Created by admin on 30.07.2022.
//

import Foundation

struct NewsModel:Codable{
    let articles: Articles
}

struct Articles:Codable{
    let results: [Result]
}

struct Result:Codable{
    let uri:String
    let title:String
    let body: String
    let image: String?
    let date:String
}
