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
                        pokemonVM.restart()
                    } label: {
                        RestartButtonView(loading: pokemonVM.loading)
                    }
                    Spacer()
                }
                Spacer()
            }
            .padding()
            .padding(.top)
            
                if (pokemonVM.loading) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 50)
                            .fill(.white)
                        Text("Loading...")
                            .font(.title2)
                    }
                    .frame(width: 300, height: 480)
                } else {
                    PokeCardContentView(pokemon: pokemonVM.pokemons[pokemonVM.frontIndex])
                        .flippable(isFront: pokemonVM.isFront, direction: pokemonVM.directions[pokemonVM.index], pokemon: pokemonVM.pokemons[pokemonVM.backIndex])
                        .frame(width: 300, height: 480)
                        .onTapGesture {
                            withAnimation() {
                                pokemonVM.flipCard()
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

