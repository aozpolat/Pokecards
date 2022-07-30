//
//  PokemonViewModel.swift
//  Pokecards
//
//  Created by abdulk on 30/07/2022.
//

import Foundation

class PokemonViewModel : ObservableObject{
    @Published var pokemons = Pokemons(results: [])
    
    init () {
        fetchPokemons()
    }
}


extension PokemonViewModel {
    func fetchPokemons() {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon/") else {
            print("url error")
            return;
        }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, res, err in
            if let data = data {
                if let response = try? JSONDecoder().decode(Pokemons.self, from: data) {
                    DispatchQueue.main.async { [weak self] in
                        self?.pokemons = response
                    }
                }
            }
        }.resume()
    }
}
