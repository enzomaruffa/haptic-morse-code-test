//
//  MorseCharacterFactory.swift
//  haptic-morse-code-test
//
//  Created by Enzo Maruffa Moreira on 16/02/20.
//  Copyright © 2020 Enzo Maruffa Moreira. All rights reserved.
//

import CoreHaptics

class MorseCharacterFactory {
    
    static let unitLength: Double = 0.1
    static var dotLength: Double {
        1 * unitLength
    }
    static var dashLength: Double {
        3 * unitLength
    }
    static var innerCharacterSpacing: Double  {
        1 * unitLength
    }
    static var characterSpacing: Double  {
        3 * unitLength
    }
    static var wordSpacing: Double  {
        7 * unitLength
    }
    
    static func createDot(withDelay delay: Double = 0) -> CHHapticEvent {
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
        
        let event = CHHapticEvent(eventType: .hapticContinuous, parameters: [intensity, sharpness], relativeTime: delay, duration: dotLength)
        
        print("      Creating DOT with length \(dotLength)")
        
        return event
    }
    
    static func createDash(withDelay delay: Double = 0) -> CHHapticEvent {
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
        
        let event = CHHapticEvent(eventType: .hapticContinuous, parameters: [intensity, sharpness], relativeTime: delay, duration: dashLength)
        
        print("      Creating DASH with length \(dashLength)")
        
        return event
    }
    
    static func createCharacter(_ character: Character, initialDelay: Double = 0) -> MorseCharacter? {
        
        var currentDelay = initialDelay
        var events: [CHHapticEvent] = []
        
        switch character.lowercased() {
            
        case "a":
            events.append(createDot(withDelay: currentDelay))
            currentDelay += dotLength + innerCharacterSpacing
            
            events.append(createDash(withDelay: currentDelay))
            
        case "b":
            events.append(createDash(withDelay: currentDelay))
            currentDelay += dashLength + innerCharacterSpacing
            
            events.append(createDot(withDelay: currentDelay))
            currentDelay += dotLength + innerCharacterSpacing
            
            events.append(createDot(withDelay: currentDelay))
            currentDelay += dotLength + innerCharacterSpacing
            
            events.append(createDot(withDelay: currentDelay))
            
        case "c":
            events.append(createDash(withDelay: currentDelay))
            currentDelay += dashLength + innerCharacterSpacing
            
            events.append(createDot(withDelay: currentDelay))
            currentDelay += dotLength + innerCharacterSpacing
            
            events.append(createDash(withDelay: currentDelay))
            currentDelay += dashLength + innerCharacterSpacing
            
            events.append(createDot(withDelay: currentDelay))
            
        case "d":
            events.append(createDash(withDelay: currentDelay))
            currentDelay += dashLength + innerCharacterSpacing
            
            events.append(createDot(withDelay: currentDelay))
            currentDelay += dotLength + innerCharacterSpacing
            
            events.append(createDot(withDelay: currentDelay))
            
        case "e":
            events.append(createDot(withDelay: currentDelay))
            
        case "f":
            events.append(createDot(withDelay: currentDelay))
            currentDelay += dotLength + innerCharacterSpacing
            
            events.append(createDot(withDelay: currentDelay))
            currentDelay += dotLength + innerCharacterSpacing
            
            events.append(createDash(withDelay: currentDelay))
            currentDelay += dashLength + innerCharacterSpacing
            
            events.append(createDot(withDelay: currentDelay))
            
        case "g":
            events.append(createDash(withDelay: currentDelay))
            currentDelay += dashLength + innerCharacterSpacing
            
            events.append(createDash(withDelay: currentDelay))
            currentDelay += dashLength + innerCharacterSpacing
            
            events.append(createDot(withDelay: currentDelay))
            
        case "h":
            events.append(createDot(withDelay: currentDelay))
            currentDelay += dotLength + innerCharacterSpacing
            
            events.append(createDot(withDelay: currentDelay))
            currentDelay += dotLength + innerCharacterSpacing
            
            events.append(createDot(withDelay: currentDelay))
            currentDelay += dotLength + innerCharacterSpacing
            
            events.append(createDot(withDelay: currentDelay))
            
        case "i":
            events.append(createDot(withDelay: currentDelay))
            currentDelay += dotLength + innerCharacterSpacing
            
            events.append(createDot(withDelay: currentDelay))
            
        default:
            return nil
        }
        
        let morseCharacter = MorseCharacter(char: character.lowercased(), pattern: events)
        print("    Creating CHARACTER \(morseCharacter.char) with length \(morseCharacter.totalPlayTime)")
        
        return morseCharacter
    }
    
    
    static func createWord(_ characters: String, initialDelay: Double = 0) -> [MorseCharacter]? {
        guard !characters.contains(" ") else { return nil }
        
        var currentDelay = initialDelay
        var morseCharacters: [MorseCharacter] = []
        
        for character in characters {
            print("  CREATING CHARACTER \(character) WITH DELAY: \(currentDelay)")
            if let morseCharacter = createCharacter(character, initialDelay: currentDelay) {
                currentDelay += morseCharacter.totalPlayTime + characterSpacing
                morseCharacters.append(morseCharacter)
                print("  CURRENT DELAY IN WORD: \(currentDelay)")
            } else {
                return nil
            }
        }
        
        return morseCharacters
    }
    
    static func createPhrase(_ phrase: String, initialDelay: Double = 0) -> [MorseCharacter]? {
        
        var currentDelay = initialDelay
        var morseCharacters: [MorseCharacter] = []
        
        let words = phrase.split(separator: " ").map({ String($0) })
        
        for word in words {
            print("CREATING WORD \(word) WITH DELAY: \(currentDelay)")
            if let wordMorseCharacters = createWord(word, initialDelay: currentDelay) {
                
                // We add the total play time, plus each space between characters except the last one
                let wordPlayTime = wordMorseCharacters.reduce(0, { $0 + $1.totalPlayTime }) + innerCharacterSpacing * Double(wordMorseCharacters.count - 1)
                currentDelay += wordPlayTime + wordSpacing
                
                print("WORD DURATION: \(wordPlayTime), WORD SPACING: \(wordSpacing)")
                
                morseCharacters.append(contentsOf: wordMorseCharacters)
                
                print("CURRENT DELAY IN PHRASE: \(currentDelay)")
            } else {
                return nil
            }
        }
        
        return morseCharacters
    }
    
}
