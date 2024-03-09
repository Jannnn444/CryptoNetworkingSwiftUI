//
//  ContentView.swift
//  CryptoNetworkingSwiftUI
//
//  Created by yucian huang on 2024/3/6.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = CoinViewModel()
    
    var body: some View {
      
        List {
            ForEach(viewModel.coins) { coin in
                HStack(spacing: 12 ){
                    Text("\(coin.marketCapRank)")
                        .foregroundColor(.gray)
                    VStack(alignment: .leading){
                        Text(coin.name)
                            .fontWeight(.semibold)
                        Text(coin.symbol.uppercased())
                    }
                }
                .font(.footnote)
            }
        }
        .overlay {
            if let error = viewModel.errorMessage {
                Text(error)
            }
        }
    }
}

#Preview {
    ContentView()
}
