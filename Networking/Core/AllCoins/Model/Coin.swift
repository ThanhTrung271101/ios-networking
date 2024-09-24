//
//  Coin.swift
//  Networking
//
//  Created by Thành Trung on 25/9/24.
//

import Foundation

struct Coin: Codable, Identifiable {
    let id: String
    let symbol: String
    let name: String
//    let currentPrice: Double
//    let marketCapRank: Int
}
