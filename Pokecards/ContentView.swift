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
            
            Group {
                if (pokemonVM.loading) {
                    ZStack {
                        RoundedRectangle(cornerRadius: PokeConstants.cornerRadius)
                            .fill(.white)
                        Text("Loading...")
                            .font(.title2)
                    }
                    
                } else {
                    Group {
                        if (pokemonVM.shouldFetch && pokemonVM.isFront) {
                            Text("Loading..")
                                .font(.title2)
                        } else {
                            PokeCardContentView(pokemon: pokemonVM.pokemons[pokemonVM.frontIndex])
                        }
                        
                    }
                    
                        .flippable(isFront: pokemonVM.isFront, direction: pokemonVM.directions[pokemonVM.index], pokemon: pokemonVM.pokemons[pokemonVM.backIndex])
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: PokeConstants.animationTime)) {
                                pokemonVM.flipCard()
                            }
                        }
                }
            }
            .frame(width: PokeConstants.cardWidth, height: PokeConstants.cardHeight)
                
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
                .frame(width: PokeConstants.refreshButtonCircleSize, height: PokeConstants.refreshButtonCircleSize)
            Image(systemName: "arrow.clockwise")
                .foregroundColor(loading ? PokeConstants.refreshButtonColorLoading : PokeConstants.backgroundColor)
                .font(Font.system(size: PokeConstants.refreshButtonSize, weight: .black))
        }
    }
}

