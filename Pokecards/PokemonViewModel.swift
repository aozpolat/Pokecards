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
    @Published var isFront = false
    @Published var index = 0
    @Published var frontIndex = 0
    @Published var backIndex = 1
    
    private var pokemonCount: Int?
    private var pokemonDetails: [PokemonDetail] = []
    private var cardTapped = false
    let directions: [[(CGFloat, CGFloat, CGFloat)]] = [[(1,0,0.2),(1,0,0.1), (1,0,0)],[(0,-2,-0.1), (0,-2, -0.1),(0,-1,0)]]
    
    init () {
        fetchPokemons()
    }
    
    
    
    // intents
    
    func flipCard() {
        if (!cardTapped) {
            cardTapped = true;
            isFront.toggle()
            Timer.scheduledTimer(withTimeInterval: PokeConstants.animationTime, repeats: false) { [weak self] _ in
                guard let self = self else { return }
                self.index = ( self.index + 1 ) % (self.directions.count)
                if (self.isFront) {
                    self.frontIndex = ( self.frontIndex + 2 ) % self.pokemons.count
                } else {
                    self.backIndex = ( self.backIndex + 2 ) % self.pokemons.count
                }
                self.cardTapped = false
            }
        }
    }
    
    func restart() {
        frontIndex = 0; backIndex = 1; isFront = false; index = 0
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
                        self?.pokemonCount = response.results.count
                        response.results.forEach { pokemonBaseInfo in
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
                        self?.createPokemons(for: response)
//                        if (self?.pokemonDetails.count == self?.pokemonBaseInfos.results.count) {
//                            print("done details")
//                            self?.pokemonDetails = self?.pokemonDetails.sorted { $0.id < $1.id} ?? []
//                            self?.createPokemons()
//                        }
                    }
                }
            }
        }.resume()
    }
    
    func createPokemons(for pokemonDetails: PokemonDetail) {
        fetchPokemonImage(from: pokemonDetails.sprites.other.home.frontDefault.absoluteString) { data in
            print(" \(pokemonDetails.id) image")
            let newPokemon = Pokemon(id: pokemonDetails.id, name: pokemonDetails.name, image: data, hp: pokemonDetails.stats[PokeConstants.hpIndex].baseStat, attack: pokemonDetails.stats[PokeConstants.attackIndex].baseStat, defense: pokemonDetails.stats[PokeConstants.defenseIndex].baseStat)
            self.pokemons.append(newPokemon)
            if (self.pokemons.count == self.pokemonCount) { // finished
                self.pokemons = self.pokemons.sorted { $0.id < $1.id }
                self.loading = false
            }
        }
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


