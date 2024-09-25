//
//  CoinsViewModel.swift
//  Networking
//
//  Created by Thành Trung on 22/9/24.
//

import Foundation

class CoinsViewModel: ObservableObject {
    
    @Published var coins = [Coin]()
    @Published var errorMessage: String?
    
    private let service = CoinDataService()
    
    init() {
        Task {
            try await fetchCoin()
        }
    }
    
    func fetchCoin() async throws {
        self.coins = try await service.fetchCoins()
    }
    
    func fetchCoinWithCompletionHandler() {
        
        service.fetchCoinWithResult { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let coins):
                    self?.coins = coins
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                } 
            }
        }
    }
    
}
