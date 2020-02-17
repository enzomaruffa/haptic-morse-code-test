//
//  HapticManager.swift
//  haptic-morse-code-test
//
//  Created by Enzo Maruffa Moreira on 16/02/20.
//  Copyright © 2020 Enzo Maruffa Moreira. All rights reserved.
//

import CoreHaptics

class HapticManager {
    
    static let shared = HapticManager()
    
    var engine: CHHapticEngine?
    
    private func checkAvailability() -> Bool {
        CHHapticEngine.capabilitiesForHardware().supportsHaptics
    }
    
    private init() {
        guard checkAvailability() else { return }
        
        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("There was an error creating the engine: \(error.localizedDescription)")
        }

        engine?.stoppedHandler = { reason in
            print("The engine stopped: \(reason)")
        }

        // If something goes wrong, attempt to restart the engine immediately
        engine?.resetHandler = { [weak self] in
            print("The engine reset")
            do {
                try self?.engine?.start()
            } catch {
                print("Failed to restart the engine: \(error)")
            }
        }
        
    }
    
    func play(_ character: MorseCharacter) {
        do {
            let pattern = try CHHapticPattern(events: character.pattern, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription).")
        }
    }
    
    func play(_ characters: [MorseCharacter]) {
        characters.forEach({ self.play($0) })
    }
}
