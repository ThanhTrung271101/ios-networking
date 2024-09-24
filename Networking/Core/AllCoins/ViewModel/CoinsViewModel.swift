//
//  CoinsViewModel.swift
//  Networking
//
//  Created by Thành Trung on 22/9/24.
//

import Foundation

class CoinsViewModel: ObservableObject {
    
    @Published var coins = [Coin]()
    
    private let service = CoinDataService()
    
    init() {
        fetchCoin()
    }
    
    func fetchCoin() {
        service.fetchCoin { coins in
            DispatchQueue.main.async {
                self.coins = coins
            }
        }
    }
    
}
