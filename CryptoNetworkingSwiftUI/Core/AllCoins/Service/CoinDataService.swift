//
//  CoinDataService.swift
//  CryptoNetworkingSwiftUI
//
//  Created by yucian huang on 2024/3/8.
//

import Foundation


class CoinDataService {
    
    private let urlString = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=50&page=1&sparkline=false&price_change_percentage=24h&locale=en"
    
// MARK: - Async Await
        
    func fetchCoins() async throws -> [Coin] {
        guard let url = URL(string: urlString) else { return [] }
        
        print("DEBUG: Fetching data...")
        
        do {
            // get data response from url w/o completionHandler, try wait for the result of this api call to come back
            let (data, _) = try await URLSession.shared.data(from: url)
            let coins = try JSONDecoder().decode([Coin].self, from: data)
            
            return coins
        } catch {
            print("DEBUG: Error \(error.localizedDescription)")
            return []
        }

    }
    
}


//MARK: = Completion Handlers
extension CoinDataService {
    func fetchCoinsWithResult( completion: @escaping(Result<[Coin], CoinAPIError>) -> Void ) {
        
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
                let coins = try? JSONDecoder().decode([Coin].self, from: data)
                 completion(.success(coins!))
            } catch {
                print("DEBUG: Failed to decode with error \(error)")
                completion(.failure(.jsonParsingFailure))
            }
           
        }.resume()  //everytime aysnc network
    }

    func fetchPrice(coin: String, completion: @escaping((Double) -> Void)) {                                 //custom completionHandler
       
        let urlString = "https://api.coingecko.com/api/v3/simple/price?ids=\(coin)&vs_currencies=usd"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("DEBUG: Failed with errpr \(error.localizedDescription)")
//                 self.errorMessage = error.localizedDescription
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
               
//                 self.errorMessage = "Bad HTTP Response"
                return
            }
            guard httpResponse.statusCode == 200 else {
//                 self.errorMessage = "Failed to fetch with status code."
                return
            }
            
            print("DEBUG: Response code is \(httpResponse.statusCode)")
            
            guard let data = data else { return }                                            //make sure we have data first then jasonSeserialKileer
            guard let jasonObject = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else { return }  //transfer json into dictionary
            guard let value = jasonObject[coin] as? [String: Double] else {
                print("Failed to parse value")
                return
            }
            guard let price = value["usd"] else { return }
            
            print("DEBUG: Price in service id \(price).")
            completion(price)
            
        }.resume()
    }
    
    
}
