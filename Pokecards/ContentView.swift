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
        ZStack {
            PokeConstants.backgroundColor
                .ignoresSafeArea()
            VStack{
                HStack{
                    Button {
                    } label: {
                        RestartButtonView(loading: pokemonVM.loading)
                    }
                    Spacer()
                }
                Spacer()
            }
            .padding()
            .padding(.top)

            ZStack {
                RoundedRectangle(cornerRadius: 50)
                    .fill(.white)
                if (pokemonVM.loading) {
                    Text("Loading")
                } else {
                    PokeCardContentView(pokemon: pokemonVM.pokemons[0])
                }
            }
                .frame(width:   300, height: 500) 
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct RestartButtonView: View {
    var loading: Bool
    var body: some View {
        ZStack {
            Circle()
                .fill(.white)
                .frame(width: 50, height: 50)
            Image(systemName: "arrow.clockwise")
                .foregroundColor(loading ? PokeConstants.refreshButtonColorLoading : PokeConstants.backgroundColor)
                .font(Font.system(size: 25, weight: .black))
        }
    }
}
