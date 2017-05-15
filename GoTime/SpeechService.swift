//
//  SpeechService.swift
//  GoTime
//
//  Created by John Keith on 4/13/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import Foundation
import AVFoundation

// TODO: UNTESTED
class SpeechService: NSObject, AVSpeechSynthesizerDelegate {
    let synth = AVSpeechSynthesizer()
    
    override init() {
        super.init()
        
        synth.delegate = self
        
        setAudioDefaults()
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        deactivateAudio()
    }
    
    func speakTimerPaused() {
        textToSpeech(text: "Paused")
    }
    
    func speakTimerCleared() {
        textToSpeech(text: "Cleared")
    }
    
    func speakPreviousLapTime(timeTuple: (minutes: String, seconds: String, fraction: String), lapNumber: Int) {
        let lapNumberOrdinalized = "\(lapNumber)\(Constants.ordinalSuffixForNumber(number: lapNumber))"
        let sentancePrefix = "\(lapNumberOrdinalized) lap time"
        
        speakSentanceAboutTime(timeTuple: timeTuple, sentancePrefix: sentancePrefix)
    }
    
    func speakAverageLapTime(timeTuple: (minutes: String, seconds: String, fraction: String)) {
        let sentancePrefix = "Average lap time"
        
        speakSentanceAboutTime(timeTuple: timeTuple, sentancePrefix: sentancePrefix)
    }
    
    func speakTotalTime(timeTuple: (minutes: String, seconds: String, fraction: String)) {
        let sentancePrefix = "Total running time is"
        
        speakSentanceAboutTime(timeTuple: timeTuple, sentancePrefix: sentancePrefix)
    }
    
    private func speakSentanceAboutTime(timeTuple: (minutes: String, seconds: String, fraction: String), sentancePrefix: String) {
        let milliseconds = timeTuple.fraction
        let minutesInt = Int(timeTuple.minutes)
        let secondsInt = Int(timeTuple.seconds)
        
        var sentanceToSpeak = sentancePrefix
        
//        TODO - NOT WORKING
        if minutesInt! > 0 {
            sentanceToSpeak += " \(minutesInt!) minute"
        }
        
        if minutesInt! > 1 {
            sentanceToSpeak += "s"
        }
        
        if minutesInt! > 0 && secondsInt! > 0 {
            sentanceToSpeak += " and"
        }
        
        if secondsInt! > 0 {
            sentanceToSpeak += " \(secondsInt!) point \(milliseconds) seconds"
        }
        
        textToSpeech(text: sentanceToSpeak)
    }
    
    private func textToSpeech(text: String) {
        let myUtterance = AVSpeechUtterance(string: text)
        myUtterance.rate = 0.5
        
        activateAudioAndSpeak(utterance: myUtterance)
    }
    
    private func activateAudioAndSpeak(utterance: AVSpeechUtterance) {
        DispatchQueue.global(qos: .background).async {
            do {
                try AVAudioSession.sharedInstance().setActive(true)
                self.synth.speak(utterance)
            } catch {
                print("there was an error activating audio")
            }
        }
    }
    
    private func deactivateAudio() {
        DispatchQueue.global(qos: .background).async {
            do {
                try AVAudioSession.sharedInstance().setActive(false)
            } catch {
                print("there was an error deactivating audio")
            }
        }
    }
    
    private func setAudioDefaults() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: [AVAudioSessionCategoryOptions.duckOthers, AVAudioSessionCategoryOptions.interruptSpokenAudioAndMixWithOthers])
        } catch {
            print("there was an error setting audio defaults")
        }
    }
}
