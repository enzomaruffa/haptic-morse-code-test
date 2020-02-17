//
//  MorseCharacterFactory.swift
//  haptic-morse-code-test
//
//  Created by Enzo Maruffa Moreira on 16/02/20.
//  Copyright © 2020 Enzo Maruffa Moreira. All rights reserved.
//

import CoreHaptics

class MorseCharacterFactory {
    
    static let unitLength: Double = 0.15
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
    
    static private func getMorseSignals(for character: Character) -> [MorseSignalType]? {
        switch character {
        case "a":
            return [.dot, .dash]
        case "b":
            return [.dash, .dot, .dot, .dot]
        case "c":
            return [.dash, .dot, .dash, .dot]
        case "d":
            return [.dash, .dot, .dot]
        case "e":
            return [.dot]
        case "f":
            return [.dot, .dot, .dash, .dot]
        case "g":
            return [.dash, .dash, .dot]
        case "h":
            return [.dot, .dot, .dot, .dot]
        case "i":
            return [.dot, .dot]
        case "j":
            return [.dot, .dash, .dash, .dash]
        case "k":
            return [.dash, .dot, .dash]
        case "l":
            return [.dot, .dash, .dot, .dot]
        case "m":
            return [.dash, .dash]
        case "n":
            return [.dash, .dot]
        case "o":
            return [.dash, .dash, .dash]
        case "p":
            return [.dot, .dash, .dash, .dot]
        case "q":
            return [.dash, .dash, .dot, .dash]
        case "r":
            return [.dot, .dash, .dot]
        case "s":
            return [.dot, .dot, .dot]
        case "t":
            return [.dash]
        case "u":
            return [.dot, .dot, .dash]
        case "v":
            return [.dot, .dot, .dot, .dash]
        case "w":
            return [.dot, .dash, .dash]
        case "x":
            return [.dash, .dot, .dot, .dash]
        case "y":
            return [.dash, .dot, .dash, .dash]
        case "z":
            return [.dash, .dash, .dot, .dot]
        case "1":
            return [.dot, .dash, .dash, .dash, .dash]
        case "2":
            return [.dot, .dot, .dash, .dash, .dash]
        case "3":
            return [.dot, .dot, .dot, .dash, .dash]
        case "4":
            return [.dot, .dot, .dot, .dot, .dash]
        case "5":
            return [.dot, .dot, .dot, .dot, .dot]
        case "6":
            return [.dash, .dot, .dot, .dot, .dot]
        case "7":
            return [.dash, .dash, .dot, .dot, .dot]
        case "8":
            return [.dash, .dash, .dash, .dot, .dot]
        case "9":
            return [.dash, .dash, .dash, .dash, .dot]
        case "0":
            return [.dash, .dash, .dash, .dash, .dash]
        default:
            return nil
        }
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
        
        guard let signals = getMorseSignals(for: character.lowercased().first!) else { return nil }
        
        for signal in signals {
            if signal == .dot {
                events.append(createDot(withDelay: currentDelay))
                currentDelay += dotLength + innerCharacterSpacing
            } else if signal == .dash {
                events.append(createDash(withDelay: currentDelay))
                currentDelay += dashLength + innerCharacterSpacing
            }
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
