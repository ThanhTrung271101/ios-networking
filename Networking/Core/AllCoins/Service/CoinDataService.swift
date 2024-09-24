//
//  CoinDataService.swift
//  Networking
//
//  Created by Thành Trung on 24/9/24.
//

import Foundation

class CoinDataService {
    
    private let urlString = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=20&page=1&sparkline=false&price_change_percentage=24h&locale=en"
    
    func fetchCoin(completion: @escaping([Coin]) -> Void) {
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            
            guard let coins = try? JSONDecoder().decode([Coin].self, from: data) else {
                print("DEBUG: Failed to decode coins")
                return
            }
            completion(coins)
        }.resume()
    }
    func fetchPrice(coin: String, completion: @escaping(Double) -> Void){
        
        let urlString = "https://api.coingecko.com/api/v3/simple/price?ids=\(coin)&vs_currencies=usd"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, respone, error in
            if let error = error {
                print("DEBUG: Failed with error \(error.localizedDescription)")
                //                    self.errorMessage = error.localizedDescription
                return
            }
            guard let httpRespone = respone as? HTTPURLResponse else {
                //                    self.errorMessage = "Bad Http Response"
                return
            }
            guard httpRespone.statusCode == 200 else {
                //                    self.errorMessage = "Failed to fetch with status code \(httpRespone.statusCode)"
                return
            }
            
//                print("DEBUG: Response code is \(httpRespone.statusCode)")
            
            guard let data = data else { return }
            guard let jsonObject = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else { return }
            guard let value = jsonObject[coin] as? [String: Double] else {
                print("DEBUG: Failed to parse value...")
                return
            }
            guard let price = value["usd"] else { return }
            
            //                self.coin = coin.capitalized
            //                self.price = "$\(price)"
            print("DEBUG: Price in service is \(price)")
            completion(price)
        }.resume()
        //    }
    }
}
