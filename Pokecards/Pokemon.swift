//
//  Pokemon.swift
//  Pokecards
//
//  Created by abdulk on 30/07/2022.
//

import Foundation

struct Pokemons: Codable {
    var results: [Pokemon]
    
    struct Pokemon: Codable{
        var name: String
        var url: String
    }
}
