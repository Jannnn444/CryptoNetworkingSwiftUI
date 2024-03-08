//
//  CoinViewModel.swift
//  CryptoNetworkingSwiftUI
//
//  Created by yucian huang on 2024/3/6.
//

import Foundation

// observable, so we can use in our main

class CoinViewModel: ObservableObject {
    
    // the properties are waiting to be upfate by our API!
    @Published var coin = ""
    @Published var price = ""
    @Published var errorMessage: String?
    init() {
        
        fetchPrice(coin: "ethereum")
    }
    
    
    func fetchPrice(coin: String) {
        print(Thread.current)
        let urlString = "https://api.coingecko.com/api/v3/simple/price?ids=\(coin)&vs_currencies=usd"
        guard let url = URL(string: urlString) else { return }  //physical url Object
        
            print("Fetching price..")
        URLSession.shared.dataTask(with: url) { data, response, error in
            print("Did received data ")  //this show when we received data from API, run successfully, BUT this session datatask's code inside our  completion block isn't going to execute UNTIL we got response back from our server!!  often called completionHandler/call back  because of this, like we got data back, received response 200 code your ok, or we potentially received an error.
            
            if let error = error {
                print("DEBUG: Failed with errpr \(error.localizedDescription)")
                return    //if error show the message, if not it keep going
            }
            
            guard let data = data else { return }   //make sure we have data first then jasonSeserialKileer
            guard let jasonObject = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else { return }  //transfer json into dictionary
            print(jasonObject)
            guard let value = jasonObject[coin] as? [String: Double] else {
                
                print("Failed to parse value")
                return
                
                }
            guard let price = value["usd"] else { return }
            
            DispatchQueue.main.sync {   
                print(Thread.current)
         // DispatchQueue got these properties ultimatily update the user interface into main thread
                self.coin = coin.capitalized
                self.price = "$\(price)"
            }
            
            
            
        }.resume()   // never forgot everytime
    
            print("Did reach end of the function.. ")
        
        // 3 print orders -> 1,3,2 because when we need a call back from API to our device need maybe 1 more secs, the API calls takes time than the rest, the code will keep continue its executin, that's why we see the 3rd print first than the 2nd
        
    }
}



