//
//  CoinDataService.swift
//  Networking
//
//  Created by Thành Trung on 24/9/24.
//

import Foundation

class CoinDataService {
    private let urlString = """
    https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1\
    &sparkline=false&price_change_percentage=24h&locale=en
    """
    func fetchCoins() async throws -> [Coin] {
        guard let url = URL(string: urlString) else { return [] }
        print("DEBUG: Fetching data ...")
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let coins = try JSONDecoder().decode([Coin].self, from: data)
            return coins
        } catch {
            print("DEBUG: Error \(error.localizedDescription)")
            return []
        }
    }
}

// MARK: - completion handlers

extension CoinDataService {
    func fetchCoinWithResult(completion: @escaping (Result<[Coin], CoinAPIError>) -> Void) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.unknownError(error: error)))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.requestFailed(description: "Request failed")))
                return
            }
            guard httpResponse.statusCode == 200 else {
                completion(.failure(.invalidStatusCode(statusCode: httpResponse.statusCode)))
                return
            }
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            do {
                let coins = try JSONDecoder().decode([Coin].self, from: data)
                completion(.success(coins))
            } catch {
                print("DEBUG: Failed to decode with error \(error)")
                completion(.failure(.jsonParsingFailure))
            }
        }.resume()
    }
    func fetchPrice(coin: String, completion: @escaping (Double) -> Void) {
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
