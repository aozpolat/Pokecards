//
//  PokemonViewModel.swift
//  Pokecards
//
//  Created by abdulk on 30/07/2022.
//

import Foundation

class PokemonViewModel : ObservableObject{
    @Published var pokemons: [Pokemon] = []
    
    var pokemonBaseInfos = PokemonBaseInfos(results: [])
    var pokemonDetails: [PokemonDetail] = []
    
    init () {
        fetchPokemons()
    }
    
    func createPokemons() -> [Pokemon] {
        var result: [Pokemon] = []
        for index in 0..<pokemonDetails.count {
            let currentPokemon = pokemonBaseInfos.results[index]
            let currentPokemonDetails = pokemonDetails[index]
            let newPokemon = Pokemon(id: currentPokemonDetails.id, name: currentPokemon.name, imageUrl: currentPokemonDetails.sprites.frontDefault, hp: currentPokemonDetails.stats[PokeConstants.hpIndex].baseStat, attack: currentPokemonDetails.stats[PokeConstants.attackIndex].baseStat, defense: currentPokemonDetails.stats[PokeConstants.defenseIndex].baseStat)
            result.append(newPokemon)
        }
        return result
    }
}


extension PokemonViewModel {
    func fetchPokemons() {
        guard let url = URL(string: PokeConstants.pokeApiUrl) else {
            print("url error")
            return;
        }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, res, err in
            if let data = data {
                if let response = try? JSONDecoder().decode(PokemonBaseInfos.self, from: data) {
                    DispatchQueue.main.async { [weak self] in
                        self?.pokemonBaseInfos = response
                        self?.pokemonBaseInfos.results.forEach { pokemonBaseInfo in
                            self?.fetchPokemonDetails(url:pokemonBaseInfo.url.absoluteString)
                        }
                    }
                }
            }
        }.resume()
    }
    
    func fetchPokemonDetails(url : String) {
        guard let url = URL(string: url) else {
            print("url error")
            return;
        }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, res, err in
            if let data = data {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                if let response = try? decoder.decode(PokemonDetail.self, from: data) {
                    DispatchQueue.main.async { [weak self] in
                        self?.pokemonDetails.append(response)
                        
                        if (self?.pokemonDetails.count == self?.pokemonBaseInfos.results.count) {
                            self?.pokemons = self?.createPokemons() ?? []
                        }
                        
                    }
                }
            }
        }.resume()
    }
}

// index of the stats that I use
struct PokeConstants {
    static var pokeApiUrl = "https://pokeapi.co/api/v2/pokemon/"
    static var hpIndex = 0
    static var attackIndex = 1
    static var defenseIndex = 2
}
