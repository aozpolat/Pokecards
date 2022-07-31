//
//  FlippableCard.swift
//  Pokecards
//
//  Created by abdulk on 31/07/2022.
//

import Foundation
import SwiftUI


struct FlippableCard: AnimatableModifier {
    private var rotation: Double
    private var direction:[(CGFloat, CGFloat, CGFloat)]
    private var pokemon: Pokemon
    init(isFront: Bool, direction:[(CGFloat, CGFloat, CGFloat)], pokemon: Pokemon) {
        rotation = isFront ? 180 : 0
        self.direction = direction
        self.pokemon = pokemon
    }
    
    var animatableData: Double {
        get { rotation }
        set { rotation = newValue }
    }
    
    func body(content: Content) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 50)
                .fill(.white)
            PokeCardContentView(pokemon: pokemon)
                
                .opacity(rotation < 90 ? 0.0 : 1.0)
            content
                .opacity(rotation < 90 ? 1.0 : 0.0)
        }
        .rotation3DEffect(
            Angle.degrees(rotation > 90 ? -180 + rotation : rotation),
            axis: (rotation < 60 ? direction[0] : rotation < 120 ? direction[1] : direction[2]),
            perspective: 0.2
        )
    }
}

extension View {
    func flippable(isFront: Bool, direction:[(CGFloat, CGFloat, CGFloat)], pokemon: Pokemon) -> some View {
        modifier(FlippableCard(isFront: isFront, direction: direction, pokemon: pokemon))
    }
}
