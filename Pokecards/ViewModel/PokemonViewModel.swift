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
    @Published var index = 0 //to switch between direction (Horizontal and vertical)
    @Published var frontIndex = 0 //  index of the card at the front
    @Published var backIndex = 1  //  index of the card at the back
    @Published var usePrevious = false
    
    private var pokeApiService = PokeApiService()
    private var pokemonCount: Int?
    private var nextUrl: URL?
    private var cardTapped = false
    private var shouldChangeSet = false
    private var url: String {
        nextUrl == nil ? PokeConstants.pokeApiUrl : nextUrl!.absoluteString
    }
    let directions: [[(CGFloat, CGFloat, CGFloat)]] = [[(1,0,0.2),(1,0,0.1), (1,0,0)],[(0,-2,-0.1), (0,-2, -0.1),(0,-1,0)]] // they are like keyframes
    
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
                //change cards on the screen. For example, if user sees a card at the front then change the card at the back by adding 2
                // so, user can see smooth changes between pokemons.
                Timer.scheduledTimer(withTimeInterval: PokeConstants.animationTime, repeats: false) { [weak self] _ in
                    guard let self = self else { return }
                    self.index = ( self.index + 1 ) % (self.directions.count)
                    if (!self.isFront) {
                        // if 20. pokemon is on the screen, set shoulChangeSet to true
                        self.shouldChangeSet = self.previousPokemons.count > 0 && ((self.frontIndex + 2) % self.previousPokemons.count ) == 0
                        
                        self.frontIndex = self.usePrevious ? ( self.frontIndex + 2 ) % self.previousPokemons.count : ( self.frontIndex + 2 ) % self.pokemonCount!
                    } else {
                        // If we reached to the index of fetching new set which is 15 at the moment
                        // then 15. pokemon is on the screen, fetch the next set for better ux
                        if (( self.backIndex + 2 ) % PokeConstants.indexOfFetchingNewSet == 0 && self.previousPokemons.isEmpty && self.nextUrl != nil ) {
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
     * and use those details and the image data to create pokemons.
     *
     * This function is running in a parallel way. So, I needed to sort pokemons after fetching operations is completed.
     * It basically fetches everthing and creates pokemon, after fetching everthing sorts them.
     */
    func createPokemons() {
        pokeApiService.fetch(from: self.url) { [weak self] (pokemonBaseInfos : PokemonBaseInfos) in
            guard let self = self else {return}
            
            self.pokemonCount = pokemonBaseInfos.results.count
            self.nextUrl = pokemonBaseInfos.next
            pokemonBaseInfos.results.forEach { pokemonBaseInfo in
                self.pokeApiService.fetch(from:pokemonBaseInfo.url.absoluteString) { (pokemonDetails : PokemonDetail) in
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


