//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Evan Scharfer on 11/30/15.
//  Copyright © 2015 Evan Scharfer. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var audioPlayer:AVAudioPlayer!
    var receievedAudio: RecordedAudio!
    var myAudioFile: AVAudioFile!
    var audioEngine: AVAudioEngine!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOfURL: receievedAudio.filePathUrl)
            audioPlayer.enableRate = true
        } catch {
            print(error)
        }
        
        myAudioFile = try! AVAudioFile(
            forReading: receievedAudio.filePathUrl)
        
        audioEngine = AVAudioEngine()
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
 
    @IBAction func showPlay(sender: UIButton) {
        play(0.5)
    }

    @IBAction func fastPlay(sender: UIButton) {
        play(2)
    }
    
    @IBAction func chipmonkPlay(sender: UIButton) {
        playWithPitch(1000)
    }
    
    @IBAction func playDarth(sender: UIButton) {
        playWithPitch(-1000)
    }
    
    // Play audio with changing speeds
    func play(speed: Float) {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        audioPlayer.rate = speed
        audioPlayer.currentTime = 0
        audioPlayer.play()
    }
    
    // Play audio with chaning pitches
    func playWithPitch(pitch: Float) {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        let pitchPlayer = AVAudioPlayerNode()
        let timePitch = AVAudioUnitTimePitch()
        timePitch.pitch = pitch
        audioEngine.attachNode(pitchPlayer)
        audioEngine.attachNode(timePitch)
        
        audioEngine.connect(pitchPlayer, to: timePitch, format: nil)
        audioEngine.connect(timePitch, to: audioEngine.outputNode, format: nil)
        
        pitchPlayer.scheduleFile(myAudioFile, atTime: nil, completionHandler: nil)
        
        try! audioEngine.start()
        pitchPlayer.play()
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        audioPlayer.stop()
    }

}
