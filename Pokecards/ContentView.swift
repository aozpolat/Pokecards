//
//  ContentView.swift
//  Pokecards
//
//  Created by abdulk on 29/07/2022.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var pokemonVM = PokemonViewModel()
    @State private var isFront = false
    @State private var index = 0
    @State private var frontIndex = 0
    @State private var backIndex = 1
    @State private var clicked = false
    let directions: [[(CGFloat, CGFloat, CGFloat)]] = [[(1,0,0.2),(1,0, 0.1), (1,0,0)],[(0,-2,-0.1), (0,-2, -0.1),(0,-1,0)]]
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

            
                if (pokemonVM.loading) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 50)
                            .fill(.white)
                        Text("Loading")
                    }
                    .frame(width:   600, height: 500)
                } else {
                    PokeCardContentView(pokemon: pokemonVM.pokemons[frontIndex])
                        .flippable(isFront: isFront, direction: directions[index], pokemon: pokemonVM.pokemons[backIndex])
                        .frame(width:   600, height: 500)
                        .onTapGesture {
                            if (!clicked) {
                                clicked = true;
                                withAnimation(.easeInOut(duration: 0.6)) {
                                    isFront.toggle()
                                }
                                Timer.scheduledTimer(withTimeInterval: 0.6, repeats: false) {_ in
                                    index = ( index + 1 ) % directions.count
                                    if (isFront) {
                                        frontIndex = ( frontIndex + 2 ) % pokemonVM.pokemons.count
                                    } else {
                                        backIndex = ( backIndex + 2 ) % pokemonVM.pokemons.count
                                    }
                                    clicked = false
                                }
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
