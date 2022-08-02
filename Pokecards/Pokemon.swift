//
//  Pokemon.swift
//  Pokecards
//
//  Created by abdulk on 30/07/2022.
//

import Foundation

//for general info like urls 
struct PokemonBaseInfos: Decodable {
    var next: URL
    var results: [PokemonBaseInfo]
    
    struct PokemonBaseInfo: Decodable{
        var url: URL
    }
}

// Stat[0] -> hp, Stat[1] -> attack, Stat[2] -> defense
struct PokemonDetail: Decodable {
    var id: Int
    var name: String
    var sprites: Sprite
    var stats: [Stat]
    
    struct Sprite : Decodable{
        var other: OtherSprites
        
        struct OtherSprites : Decodable {
            var home: HomeSprites
            
            struct HomeSprites : Decodable {
                var frontDefault: URL
            }
        }
    }
    
    struct Stat : Decodable {
        var baseStat:Int
        var stat: StatDetail
    }
    
    struct StatDetail : Decodable {
        var name: String
    }
}

//Pokemons to show inside UI
struct Pokemon: Identifiable {
    let id: Int
    var name: String
    var image: Data
    var hp: Int
    var attack: Int
    var defense: Int
}
