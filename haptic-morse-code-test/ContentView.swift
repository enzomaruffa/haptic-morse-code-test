//
//  ContentView.swift
//  haptic-morse-code-test
//
//  Created by Enzo Maruffa Moreira on 16/02/20.
//  Copyright © 2020 Enzo Maruffa Moreira. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State private var alphabet = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
    
    @State private var phrase: String = ""
    
    let hapticManager = HapticManager.shared
    
    var body: some View {
        VStack {
            HStack {
                TextField("Phrase:", text: $phrase)
                Button(action: {
                    
                    if let morseCharacters = MorseCharacterFactory.createPhrase(self.phrase) {
                        self.hapticManager.play(morseCharacters)
                    }
                    
                }) {
                    Text("Play")
                }

            }.padding()
            List(alphabet, id: \.self) { character in
                Text(character)
                    .frame(minWidth: 0, idealWidth: .infinity, maxWidth: .infinity, minHeight: 0, idealHeight: 20, maxHeight: 30, alignment: .leading)
                    .onTapGesture {
                        if let morseCharacter = MorseCharacterFactory.createCharacter(character.first!) { self.hapticManager.play(morseCharacter)
                        }
                }
            }
        }.padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
