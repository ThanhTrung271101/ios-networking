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
        fetchPrice(coin: "bitcoin")
    }
    
    func fetchPrice(coin: String) {
        
        print(Thread.current)
        
        let urlString = "https://api.coingecko.com/api/v3/simple/price?ids=\(coin)&vs_currencies=usd"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, respone, error in
            print(Thread.current)

            print("DEBUG: Did receive data \(data).")
            guard let data = data else { return }
            guard let jsonObject = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else { return }
            guard let value = jsonObject[coin] as? [String: Double] else {
                print("DEBUG: Failed to parse value...")
                return
            }
            guard let price = value["usd"] else { return }
            
            DispatchQueue.main.async {
                print(Thread.current)

                self.coin = coin.capitalized
                self.price = "$\(price)"
            }
        }.resume()
    }
}
