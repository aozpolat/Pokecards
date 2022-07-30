//
//  Pokemon.swift
//  Pokecards
//
//  Created by abdulk on 30/07/2022.
//

import Foundation

//name and url for details
struct PokemonBaseInfos: Decodable {
    var results: [PokemonBaseInfo]
    
    struct PokemonBaseInfo: Decodable{
        var name: String
        var url: URL
    }
}

// Stat[0] -> hp, Stat[1] -> attack, Stat[2] -> defense
struct PokemonDetail: Decodable {
    var id: Int
    var sprites: Sprite
    var stats: [Stat]
    
    struct Sprite : Decodable{
        var frontDefault: URL
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
    var imageUrl: URL
    var hp: Int
    var attack: Int
    var defense: Int
}
