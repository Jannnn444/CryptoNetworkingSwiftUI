//
//  CoinViewModel.swift
//  CryptoNetworkingSwiftUI
//
//  Created by yucian huang on 2024/3/6.
//

import Foundation

class CoinViewModel: ObservableObject {
    
    @Published var coin = ""
    @Published var price = ""
    @Published var errorMessage: String?
    init() {
        
        fetchPrice(coin: "ethereum")
    }
    
    
    func fetchPrice(coin: String) {
       
        let urlString = "https://api.coingecko.com/api/v3/simple/price?ids=\(coin)&vs_currencies=usd"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.sync {
                
                if let error = error {
                    print("DEBUG: Failed with errpr \(error.localizedDescription)")
                    self.errorMessage = error.localizedDescription
                    return
                }
                
                guard let data = data else { return }   //make sure we have data first then jasonSeserialKileer
                guard let jasonObject = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else { return }  //transfer json into dictionary
                guard let value = jasonObject[coin] as? [String: Double] else {
                    print("Failed to parse value")
                    return
                }
                guard let price = value["usd"] else { return }
                
                self.coin = coin.capitalized
                self.price = "$\(price)"
            }
            
        }.resume()

        
    }
}



