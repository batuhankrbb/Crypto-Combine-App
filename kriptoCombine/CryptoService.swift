//
//  CryptoService.swift
//  kriptoCombine
//
//  Created by Batuhan Karababa on 19.12.2020.
//

import Foundation
import Combine







final class CryptoService{
    
    var components:URLComponents{  // url döndürüyor sadece biraz daha verimli bir şekilde
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.coinranking.com"
        components.path = "/v1/public/coins"
        components.queryItems = [URLQueryItem(name: "base", value: "USD"),
                                 URLQueryItem(name: "timePeriod", value: "24h")]
        return components
    }
    
    
    func fetchCoins() -> AnyPublisher<CryptoDataContainer,Error>{
        return URLSession.shared.dataTaskPublisher(for: components.url!)
            .map{ $0.data }
            .decode(type: CryptoDataContainer.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
}


// ---- KATMAN - 2 ----
struct CryptoDataContainer:Decodable{  // veri buna göre çekilecek bu herşeyi kaplayan bir container
    let status:String // başarılı mı değil mi
    let data:CryptoData // data isminde bir şey var ve içinde onlarca şey var biz data keywordunu alıp Cryptodata çekiyoruz - Sadece Coin
}


// ---- KATMAN - 1 ----
struct CryptoData:Decodable{
    let coins:[Coin]  // data keywordünden gelen verilerden Coinleri çekiyoruz. datada coins isminde bir keyword daha var yani onu çekiyoruz.
}

// ---- KATMAN - 0 ----
struct Coin:Decodable,Hashable{ // En küçük veri parçası. coins içinde name ve price keywordleri olan coinlerin dizisi var. Biz burada name ve price çekiyoruz. En küçüğü burası.
    let name:String
    let price:String
}
