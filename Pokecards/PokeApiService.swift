//
//  PokeApiService.swift
//  Pokecards
//
//  Created by abdulk on 02/08/2022.
//

import Foundation


struct PokeApiService {
    
    func fetchGeneric<T: Decodable> (from url: String, _ completion: @escaping (T) -> Void) {
        guard let url = URL(string: url) else {
            print("url error")
            return;
        }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, res, err in
            if let data = data {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                if let response = try? decoder.decode(T.self, from: data) {
                    DispatchQueue.main.async {
                        completion(response)
                    }
                }
            }
        }.resume()
    }
    
    func fetchPokemonImage(from url: String, completion: @escaping (_ :Data) -> Void) {
        guard let url = URL(string: url) else {
            print("url error")
            return;
        }
        
        URLSession.shared.dataTask(with: url) { data, res, err in
            if let data = data {
                DispatchQueue.main.async {
                      completion(data)
                }
            }
        }.resume()
    }
    
//    func fetchPokemons(from url: String, _ completion: @escaping (PokemonBaseInfos) -> Void) {
//        guard let url = URL(string: url) else {
//            print("url error")
//            return;
//        }
//
//        let request = URLRequest(url: url)
//
//        URLSession.shared.dataTask(with: request) { data, res, err in
//            if let data = data {
//                if let response = try? JSONDecoder().decode(PokemonBaseInfos.self, from: data) {
//                    DispatchQueue.main.async {
//                        completion(response)
//                    }
//                }
//            }
//        }.resume()
//    }
    
    
//    func fetchPokemonDetails(url : String, _ completion: @escaping (PokemonDetail) -> Void) {
//        guard let url = URL(string: url) else {
//            print("url error")
//            return;
//        }
//
//        let request = URLRequest(url: url)
//
//        URLSession.shared.dataTask(with: request) { data, res, err in
//            if let data = data {
//                let decoder = JSONDecoder()
//                decoder.keyDecodingStrategy = .convertFromSnakeCase
//                if let response = try? decoder.decode(PokemonDetail.self, from: data) {
//                    DispatchQueue.main.async {
//                        completion(response)
//                    }
//                }
//            }
//        }.resume()
//    }
}
