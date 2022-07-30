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
        ScrollView {
            ForEach(pokemonVM.pokemons) { item in
                
                VStack{
                    HStack{
                        Text(String(item.id))
                        AsyncImage(url: item.imageUrl)
                    }
                    
                }
            }
            
           
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
