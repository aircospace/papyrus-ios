//
//  Message.swift
//  Papyrus
//
//  Created by Victor Shinya on 30/07/17.
//  Copyright © 2017 aKANJ. All rights reserved.
//

import UIKit
import AudioToolbox

class SoundManager {
    
    private var loadedSoundSamples: Dictionary<String, SystemSoundID> = [:]
    private var soundPlayed: Dictionary<String, CFAbsoluteTime> = [:]
    
    static let manager = SoundManager()
    
    func playSound(name: String, vibrate: Bool) {
        DispatchQueue.main.async {
            if UIApplication.shared.applicationState != .active {
                return
            }
            
            let lastTimeSoundPlayed = self.soundPlayed[name] ?? 0
            
            let currentTime = CFAbsoluteTimeGetCurrent()
            if currentTime - lastTimeSoundPlayed < 0.25 {
                return
            }
            
            self.soundPlayed[name] = currentTime
            
            var soundId: SystemSoundID = 0
            
            if let value = self.loadedSoundSamples[name] {
                soundId = value
            } else {
                guard let resourcePath = Bundle.main.resourcePath else {
                    return
                }
                let path = resourcePath + "/" + name
                let url = URL(fileURLWithPath: path, isDirectory: false)
                
                
                AudioServicesCreateSystemSoundID(url as CFURL, &soundId)
                
                self.loadedSoundSamples[name] = soundId
            }
            
            AudioServicesPlaySystemSound(soundId)
            
            if vibrate {
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            }
        }
    }
    
}
