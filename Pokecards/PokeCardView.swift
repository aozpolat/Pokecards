//
//  PokeCardView.swift
//  Pokecards
//
//  Created by abdulk on 30/07/2022.
//

import SwiftUI

struct PokeCardView: View {
    var pokemon: Pokemon
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .fill(.white)
            
            VStack(alignment: .leading) {
                Text(pokemon.name)
                    .font(.title)
                    .fontWeight(.medium)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                Spacer()
                AsyncImage(url: pokemon.imageUrl) {image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 300, height: 300, alignment: .center)
                .frame(maxWidth: .infinity)
                Spacer()
                HStack(alignment: .center) {
                    StatView(statName: "hp", amount: pokemon.hp)
                    StatView(statName: "attack", amount: pokemon.attack)
                    StatView(statName: "defense", amount: pokemon.defense)
                    
                }
                .padding()
            }
        }
    }
}

struct StatView : View {
    var statName: String
    var amount: Int
    var body: some View {
        VStack {
            Text(statName)
                .fontWeight(.semibold)
            Text(String(amount))
                .font(.title)
                .fontWeight(.bold)
        }
        .frame(maxWidth: .infinity)
    }
    
}

struct PokeCardView_Previews: PreviewProvider {
    static var previews: some View {
        PokeCardView(pokemon: Pokemon(id: 1, name: "Bulbasaur", imageUrl: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/14.png")! , hp: 33, attack: 33, defense: 33))
    }
}
