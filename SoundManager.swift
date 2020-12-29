//
//  SoundManager.swift
//  MatchApp
//
//  Created by Vijay C on 2020-12-27.
//

import Foundation

import AVFoundation

//Create Sound Manager class
class SoundManager {
    
    var audioPlayer:AVAudioPlayer?
    
    //Create enum cases for different sounds to be played
    enum SoundEffect {
        case flip
        case match
        case nomatch
        case shuffle
    }
    
    func playSound(effect: SoundEffect) {
        
        var soundFilename = ""
        
        switch effect {
        
            case .flip:
                soundFilename = "cardflip"
            
            case .match:
                soundFilename = "dingCorrect"
            
            case.nomatch:
                soundFilename = "dingWrong"
            
            case.shuffle:
                soundFilename = "shuffle"
        }
        //Get the path to the sound file within the app bundle. Could be nil, hence check!
        let bundlePath = Bundle.main.path(forResource: soundFilename, ofType: ".wav")
        
        //Check whether bundle path is nil
        guard bundlePath != nil else {
            //Couldn't find the sound file so exit!
            return
        }
        let url = URL(fileURLWithPath: bundlePath!)
        
        do {
            
            //Create the audio player
            audioPlayer = try AVAudioPlayer(contentsOf: url)

            //Play the sound file
            audioPlayer?.play()
        }
        catch {
            print("Couldn't create the audio player!")
            return
        }
    }
}
