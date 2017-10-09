//
//  SpeechService.swift
//  GoTime
//
//  Created by John Keith on 4/13/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import Foundation
import AVFoundation

enum SpeechTypes {
    case TimerStarted
    case TimerPaused
    case TimerCleared
    case TimerRestarted
    case PreviousAndAverageLapTimes
}

// TODO: UNTESTED
class SpeechService: NSObject, AVSpeechSynthesizerDelegate {
    let synth = AVSpeechSynthesizer()
    var voiceQueue = [SpeechTypes]()
    
    override init() {
        super.init()
        
        synth.delegate = self
        
        setAudioDefaults()
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        if voiceQueue.count > 0 {
            voiceQueue.remove(at: 0)
        }
        
        deactivateAudio()
    }
    
    func speakTimerStarted() {
        if !voiceQueue.contains(where: {$0 == SpeechTypes.TimerStarted}) {
            textToSpeech(text: "Start")
            voiceQueue.append(SpeechTypes.TimerStarted)
        }
    }
    
    func speakTimerPaused() {
        if !voiceQueue.contains(where: {$0 == SpeechTypes.TimerPaused}) {
            textToSpeech(text: "Pause")
            voiceQueue.append(SpeechTypes.TimerPaused)
        }
    }
    
    func speakTimerCleared() {
        if !voiceQueue.contains(where: {$0 == SpeechTypes.TimerCleared}) {
            textToSpeech(text: "Clear")
            voiceQueue.append(SpeechTypes.TimerCleared)
        }
    }
    
    func speakTimerRestarted() {
        if !voiceQueue.contains(where: {$0 == SpeechTypes.TimerRestarted}) {
            textToSpeech(text: "Resume")
            voiceQueue.append(SpeechTypes.TimerRestarted)
        }
    }
    
    // TODO: UNTESTED
    func speakPreviousAndAverageLapTimes(previous: (minutes: String, seconds: String, fraction: String), average: (minutes: String, seconds: String, fraction: String), lapNumber: Int) {
        let lapNumberOrdinalized = "\(lapNumber)\(Constants.ordinalSuffixForNumber(number: lapNumber))"
        let previousLapTime = convertTimeTupleToString(previous)
        let averageLapTime = convertTimeTupleToString(average)
        var sentanceToSpeak = "\(lapNumberOrdinalized) lap \(previousLapTime)."
        
        if lapNumber > 1 {
           sentanceToSpeak += "Average \(averageLapTime)."
        }
        
        textToSpeech(text: sentanceToSpeak)
        voiceQueue.append(SpeechTypes.PreviousAndAverageLapTimes)
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
    
    private func speakTotalTime(timeTuple: (minutes: String, seconds: String, fraction: String)) {
        let sentancePrefix = "Total running time is"
        
        speakSentanceAboutTime(timeTuple: timeTuple, sentancePrefix: sentancePrefix)
    }
//    end not in use
    
    private func speakSentanceAboutTime(timeTuple: (minutes: String, seconds: String, fraction: String), sentancePrefix: String) {
        var sentanceToSpeak = sentancePrefix
        sentanceToSpeak += convertTimeTupleToString(timeTuple)
        
        textToSpeech(text: sentanceToSpeak)
    }
    
    private func convertTimeTupleToString(_ timeTuple: (minutes: String, seconds: String, fraction: String)) -> String {
        
        let milliseconds = timeTuple.fraction
        let minutesInt = Int(timeTuple.minutes)
        let secondsInt = Int(timeTuple.seconds)
        
        var result: String = ""
        
        //        TODO - NOT WORKING
        if minutesInt! > 0 {
            result += " \(minutesInt!) minute"
        }
        
        if minutesInt! > 1 {
            result += "s"
        }
        
        if minutesInt! > 0 && secondsInt! > 0 {
            result += " and"
        }
        
        if secondsInt! > 0 {
            result += " \(secondsInt!) point \(milliseconds) seconds"
        }
        
        return result
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
