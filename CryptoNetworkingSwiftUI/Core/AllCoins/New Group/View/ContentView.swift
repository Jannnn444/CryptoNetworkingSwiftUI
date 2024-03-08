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
        VStack {
            
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
            } else {
                Text("\(viewModel.coin):\(viewModel.price)")
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
