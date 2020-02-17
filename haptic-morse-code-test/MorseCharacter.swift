//
//  MorseCharacter.swift
//  haptic-morse-code-test
//
//  Created by Enzo Maruffa Moreira on 16/02/20.
//  Copyright © 2020 Enzo Maruffa Moreira. All rights reserved.
//

import CoreHaptics

class MorseCharacter {
    
    let char: String
    let pattern: [CHHapticEvent]
    let totalPlayTime: Double
    
    internal init(char: String, pattern: [CHHapticEvent]) {
        self.char = char
        self.pattern = pattern
        
        if let first = pattern.first,
            let last = pattern.last {
            self.totalPlayTime = last.relativeTime + last.duration - first.relativeTime
        } else {
            self.totalPlayTime = 0
        }
    }
    
}
