//
//  PokemonViewModel.swift
//  Pokecards
//
//  Created by abdulk on 30/07/2022.
//

import Foundation
import UIKit

class PokemonViewModel : ObservableObject{
    @Published var pokemons: [Pokemon] = []
    @Published var loading = true
    var pokemonBaseInfos = PokemonBaseInfos(results: [])
    var pokemonDetails: [PokemonDetail] = []
    init () {
        fetchPokemons()
    }
    
    let dispatchQueue = DispatchQueue(label: "imageQueue", qos: .background)
    let semaphore = DispatchSemaphore(value: 0)
    
    func createPokemons() {
        for index in 0..<self.pokemonDetails.count {
                let currentPokemon = pokemonBaseInfos.results[index]
                let currentPokemonDetails = pokemonDetails[index]
                
                fetchPokemonImage(from: currentPokemonDetails.sprites.other.home.frontDefault.absoluteString) { data in
                    print(" \(currentPokemonDetails.id) image")
                    let newPokemon = Pokemon(id: currentPokemonDetails.id, name: currentPokemon.name, image: data, hp: currentPokemonDetails.stats[PokeConstants.hpIndex].baseStat, attack: currentPokemonDetails.stats[PokeConstants.attackIndex].baseStat, defense: currentPokemonDetails.stats[PokeConstants.defenseIndex].baseStat)
                    self.pokemons.append(newPokemon)
//                    if (currentPokemonDetails.id == 1) {
//                        self.pokemons = self.pokemons.sorted { $0.id < $1.id }
//                        self.loading = false
//                    }
                    if (self.pokemons.count == self.pokemonDetails.count) {
                        
                        self.pokemons = self.pokemons.sorted { $0.id < $1.id }
                        self.loading = false
                    }
                }
            }   
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
                        print(response.id)
                        if (self?.pokemonDetails.count == self?.pokemonBaseInfos.results.count) {
                            print("done details")
                            self?.pokemonDetails = self?.pokemonDetails.sorted { $0.id < $1.id} ?? []
                            self?.createPokemons()
                        }
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
}


