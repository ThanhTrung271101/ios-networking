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
    
    init() {
        fetchPrice()
    }
    
    func fetchPrice() {
        let urlString = "https://api.coingecko.com/api/v3/simple/price?ids=bitcoin&vs_currencies=usd"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, respone, error in
            print("DEBUG: Did receive data \(data).")
        }.resume()
    }
}
