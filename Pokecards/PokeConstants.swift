//
//  PokeConstants.swift
//  Pokecards
//
//  Created by abdulk on 31/07/2022.
//

import Foundation
import SwiftUI



struct PokeConstants {
    static var pokeApiUrl = "https://pokeapi.co/api/v2/pokemon/"
    
    // index of the stats that I use
    static var hpIndex = 0
    static var attackIndex = 1
    static var defenseIndex = 2
    
    // UI
    
    static var refreshButtonColorLoading = Color(hex: 0xD1D1D6)
    static var backgroundColor = Color(hex: 0xAC9EFF)
}
