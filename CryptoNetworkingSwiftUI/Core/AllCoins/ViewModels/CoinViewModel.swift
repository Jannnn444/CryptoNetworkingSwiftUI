//
//  CoinViewModel.swift
//  CryptoNetworkingSwiftUI
//
//  Created by yucian huang on 2024/3/6.
//

import Foundation

class CoinViewModel: ObservableObject {
    
    
    @Published var coins = [Coin]()
    @Published var errorMessage: String?
    
    private let service = CoinDataService()
    
    init() {
        Task { try await fetchCoins() }
    }
    
    func fetchCoins() async throws {
        self.coins = try await service.fetchCoins()    // try this api, wait for the data return, make it cecomes the slef coin value
    }
    
    func fetchCoinsWithCompletionHandler() {
 
        service.fetchCoinsWithResult { [weak self] result in
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








