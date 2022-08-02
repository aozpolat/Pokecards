//
//  PokecardsApp.swift
//  Pokecards
//
//  Created by abdulk on 29/07/2022.
//

import SwiftUI

@main
struct PokecardsApp: App {
    @StateObject var pokemonVM = PokemonViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView(pokemonVM:  pokemonVM)
        }
    }
}
