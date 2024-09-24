//
//  CoinsViewModel.swift
//  Networking
//
//  Created by Thành Trung on 22/9/24.
//

import Foundation

class CoinsViewModel: ObservableObject {
    
    @Published var coin = ""
    @Published var price = ""
    @Published var errorMessage: String?
    private let service = CoinDataService()
    
    init() {
        fetchPrice(coin: "bitcoin")
    }
    
    func fetchPrice(coin: String) {
        service.fetchPrice(coin: coin) { priceFromService in
            DispatchQueue.main.async {
                self.price = "$\(priceFromService)"
                self.coin = coin
            }
        }
    }
}
