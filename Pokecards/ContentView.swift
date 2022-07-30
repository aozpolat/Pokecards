//
//  ContentView.swift
//  Pokecards
//
//  Created by abdulk on 29/07/2022.
//

import SwiftUI

struct ContentView: View {
//    @ObservedObject var pokemonVM = PokemonViewModel()
    var body: some View {
        ZStack {
            Color.indigo
                .opacity(0.7)
                .ignoresSafeArea()
            VStack{
                HStack{
                    Button {
                    } label: {
                        RestartButtonView()
                    }
                    Spacer()
                }
                Spacer()
            }
            .padding()
            .padding(.top)

            PokeCardView(pokemon: Pokemon(id: 1, name: "Bulbasaur", imageUrl: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png")! , hp: 33, attack: 33, defense: 33))
                .frame(width: 300, height: 400)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct RestartButtonView: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(.white)
                .frame(width: 50, height: 50)
            Image(systemName: "arrow.clockwise")
                .foregroundColor(.indigo.opacity(0.7))
                .font(Font.system(size: 25, weight: .heavy))
        }
    }
}
