//
//  ContentView.swift
//  kriptoCombine
//
//  Created by Batuhan Karababa on 19.12.2020.
//

import SwiftUI
import Combine

struct CoinList: View {
    
    
    private let viewModel = CoinListViewModel()
    
    var body: some View {
        VStack{
            List(viewModel.coinViewModels,id: \.self){myModel in
                Text("\(myModel.name) - \(myModel.formattedPrice)")
            }
            .onAppear{
                viewModel.fetchCoins()
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CoinList()
    }
}



class CoinListViewModel:ObservableObject,Identifiable{
    private let cryptoService = CryptoService()
    @Published var coinViewModels = [CoinViewModel]()
    
    var cancellable:AnyCancellable?
    
    func fetchCoins(){
        cancellable = cryptoService.fetchCoins()
            .sink(receiveCompletion: { _ in
                
            }) {dataContainer in
                self.coinViewModels = dataContainer.data.coins.map{ CoinViewModel($0) }
            }
    }
    
}

struct CoinViewModel:Hashable{
    private let coin:Coin
    
    var name:String{
        return coin.name
    }
    
    var formattedPrice:String{
        
        return coin.price
    }
    
    init(_ coin: Coin){
        self.coin = coin
    }
}
