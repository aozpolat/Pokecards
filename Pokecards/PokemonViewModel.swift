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
    @Published var previousPokemons: [Pokemon] = []
    @Published var loading = true
    @Published var isFront = true
    @Published var index = 0
    @Published var frontIndex = 0
    @Published var backIndex = 1
    @Published var usePrevious = false
    
    private var pokeApiService = PokeApiService()
    private var pokemonCount: Int?
    private var nextUrl: URL?
    private var cardTapped = false
    private var shouldChangeSet = false
    private var url: String {
        nextUrl == nil ? PokeConstants.pokeApiUrl : nextUrl!.absoluteString
    }
    let directions: [[(CGFloat, CGFloat, CGFloat)]] = [[(1,0,0.2),(1,0,0.1), (1,0,0)],[(0,-2,-0.1), (0,-2, -0.1),(0,-1,0)]]
    
    init () {
        createPokemons()
    }
    
    
    
    // intents
    
    func flipCard() {
        if (!cardTapped) {
            cardTapped = true; // dont allow user to click when animation is going on
            isFront.toggle()
            if (shouldChangeSet) {
                if (pokemons.isEmpty ||  self.pokemons.count != self.pokemonCount) { //probably internet is slow, must wait
//                    print("cannot fetch new set")
                    loading = true
                    switchToNextSet()
                } else {
                    Timer.scheduledTimer(withTimeInterval: PokeConstants.animationTime / 2, repeats: false) { [weak self] _ in
                        self?.switchToNextSet()
                    }
                }
            }
            if (loading) { // we still waiting the next set to be fetched
                backIndex = 1
                self.cardTapped = false
                self.index = ( self.index + 1 ) % (self.directions.count)
            } else {
                //do something after animation time to assure nice animations
                Timer.scheduledTimer(withTimeInterval: PokeConstants.animationTime, repeats: false) { [weak self] _ in
                    guard let self = self else { return }
                    self.index = ( self.index + 1 ) % (self.directions.count)
                    if (!self.isFront) {
                        self.shouldChangeSet = self.previousPokemons.count > 0 && ((self.frontIndex + 2) % self.previousPokemons.count ) == 0 // 20. pokemon is on the screen
                        
                        self.frontIndex = self.usePrevious ? ( self.frontIndex + 2 ) % self.previousPokemons.count : ( self.frontIndex + 2 ) % self.pokemonCount!
                    } else {
                        // 15. pokemon is on the screen, fetch the next set
                        if (( self.backIndex + 2 ) % 19 == 0 && self.previousPokemons.isEmpty && self.nextUrl != nil ) {
                            self.fetchNextSetOfPokemons()
                        }
                        
                        self.backIndex = self.usePrevious ? ( self.backIndex + 2 ) % self.previousPokemons.count : ( self.backIndex + 2 ) % self.pokemonCount!
                    }
                    self.cardTapped = false
                }
            }
        }
    }
 
    func restart() {
        frontIndex = 0; backIndex = 1; isFront = true; index = 0; loading = true; nextUrl = nil
        pokemons = []; previousPokemons = []; shouldChangeSet = false; usePrevious = false
        createPokemons()
    }
}






extension PokemonViewModel {
    
    /*
     * First fetch general infos of pokemons, after that get details of them. Then, fetch their image data
     * and use those details to create pokemons.
     *
     * This function is running in a parallel way. So, I needed to sort pokemons after fetching operations is completed.
     * It basically fetches everthing and create pokemon, after fetching everthing sort them.
     */
    func createPokemons() {
        pokeApiService.fetchGeneric(from: self.url) { [weak self] (pokemonBaseInfos : PokemonBaseInfos) in
            guard let self = self else {return}
            
            self.pokemonCount = pokemonBaseInfos.results.count
            self.nextUrl = pokemonBaseInfos.next
            pokemonBaseInfos.results.forEach { pokemonBaseInfo in
                self.pokeApiService.fetchGeneric(from:pokemonBaseInfo.url.absoluteString) { (pokemonDetails : PokemonDetail) in
//                    print(pokemonDetails.id)
                    self.pokeApiService.fetchPokemonImage(from: pokemonDetails.sprites.other.home.frontDefault.absoluteString) { imageData in
//                        print(" \(pokemonDetails.id) image")
                        let newPokemon = Pokemon(id: pokemonDetails.id, name: pokemonDetails.name, image: imageData, hp: pokemonDetails.stats[PokeConstants.hpIndex].baseStat, attack: pokemonDetails.stats[PokeConstants.attackIndex].baseStat, defense: pokemonDetails.stats[PokeConstants.defenseIndex].baseStat)
                        self.pokemons.append(newPokemon)
                        if (self.pokemons.count == self.pokemonCount) { // finished
                            self.pokemons = self.pokemons.sorted { $0.id < $1.id }
                            self.loading = false
                        }
                    }
                }
            }
        }
    }
    
    /*
     * Use this function when a set is finished
     */
    func switchToNextSet() {
        usePrevious = false
        shouldChangeSet = false
        previousPokemons = [];
    }
    
    /*
     * move current pokemons into the previousPokemons array and
     * get new pokemons into the pokemons array 
     */
    func fetchNextSetOfPokemons() {
        self.previousPokemons = pokemons
        self.usePrevious = true
        pokemons = []
        createPokemons()
    }
}


