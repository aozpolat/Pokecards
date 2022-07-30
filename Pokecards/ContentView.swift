//
//  ContentView.swift
//  Pokecards
//
//  Created by abdulk on 29/07/2022.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var pokemonVM = PokemonViewModel()
    var body: some View {
        List(pokemonVM.pokemons.results, id: \.url) { item in
            VStack{
                Text(item.name)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
