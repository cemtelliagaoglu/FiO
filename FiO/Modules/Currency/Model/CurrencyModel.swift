//
//  CurrencyModel.swift
//  FiO
//
//  Created by admin on 30.07.2022.
//

import Foundation

struct CurrencyModel: Codable{
    let timestamp:Int
    let quotes:[String:Double]
}
