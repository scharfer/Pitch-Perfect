//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Evan Scharfer on 11/30/15.
//  Copyright © 2015 Evan Scharfer. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingInProgress: UILabel!
    
    @IBOutlet weak var stopButton: UIButton!
    
    @IBOutlet weak var recordButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true
        recordButton.enabled = true
    }
    
    @IBAction func recordAudio(sender: UIButton) {
        stopButton.hidden = false
        recordingInProgress.text = "recording in progress"
        recordButton.enabled = false
        
        // use document directory has file path
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        // format the audio file with timestamp
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        print(filePath)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        // start recording
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.meteringEnabled = true
        audioRecorder.delegate = self
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    
    // Stops the audio recording
    @IBAction func stopAudio(sender: UIButton) {
        recordingInProgress.text = "Tap To Record"
        stopButton.hidden = true
        recordButton.enabled = true
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }

    
    // Executed after the recording is finished and send 
    // to the next screen
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        
        if (flag) {
            // Save Audio
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
            
            // do segue to next screen
            performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            // recording as failed try again
            print("recording failed")
            stopButton.hidden = true
            recordButton.enabled = true
            recordingInProgress.text = "Tap To Record"
        }
        
    }
    
    
    // Attach audio to the next controller before sending 
    // to the next screen.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // stop recording seque activated
        if (segue.identifier == "stopRecording") {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receievedAudio = data
            
        }
    }
}

