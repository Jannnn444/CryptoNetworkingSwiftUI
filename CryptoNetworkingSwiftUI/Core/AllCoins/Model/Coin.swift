//
//  Coin.swift
//  CryptoNetworkingSwiftUI
//
//  Created by yucian huang on 2024/3/8.
//

import Foundation

struct Coin: Codable, Identifiable {
    let id: String
    let symbol: String
    let name: String
    let currentPrice: Double
    let marketCapRank: Int
    
    enum CodingKeys: String, CodingKey {   // this save the snakeCase of the server api offered, capitalized CodingKeys
        case id, symbol, name
        case currentPrice = "current_price"
        case marketCapRank = "market_cap_rank"
    }
}
