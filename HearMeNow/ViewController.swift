//
//  ViewController.swift
//  HearMeNow
//
//  Created by Enric Izquierdo on 16/10/15.
//  Copyright © 2015 Enric Izquierdo. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate {
    
    var hasRecording = false
    var soundPlayer : AVAudioPlayer?
    var soundRecorder : AVAudioRecorder?
    var session : AVAudioSession?
    var soundPath : String?
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    @IBAction func recordPressed(sender: AnyObject) {
        
        if (soundRecorder?.recording == true) {
            soundRecorder?.stop()
            recordButton.setTitle("Record", forState: UIControlState.Normal)
            hasRecording = true
        }else {
            session?.requestRecordPermission() {
                granted in
                if(granted == true) {
                    self.soundRecorder?.record()
                    self.recordButton.setTitle("Stop", forState: UIControlState.Normal)
                }else {
                    print("Unable to record")
                }
            }
        }
        
    }
    @IBAction func playPressed(sender: AnyObject) {
        
        if (soundPlayer?.playing == true) {
            soundPlayer?.pause()
            playButton.setTitle("Play", forState: UIControlState.Normal)
        }else if (hasRecording == true) {
            
            let url = NSURL(fileURLWithPath: soundPath!)
            
            var errorPlayer : NSError?
            
            do {
                try soundPlayer = AVAudioPlayer(contentsOfURL: url)
            }catch let error as NSError {
                errorPlayer = error
            }
            
            if (errorPlayer == nil) {
                soundPlayer?.delegate = self
                soundPlayer?.enableRate = true
                soundPlayer?.rate = 0.5
                soundPlayer?.play()
            }else {
                print("Error initializing player: \(errorPlayer?.description)")
            }
        }else if (soundPlayer != nil) {
            soundPlayer?.play()
            playButton.setTitle("Pause", forState: UIControlState.Normal)
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        soundPath = "\(NSTemporaryDirectory())hearmenow.wav"
        let url = NSURL(fileURLWithPath: soundPath!)
        
        session = AVAudioSession.sharedInstance()
        do {
            try session?.setActive(true)
            try session?.setCategory(AVAudioSessionCategoryPlayAndRecord)
        }catch let error as NSError {
            print("Session error: \(error.description)")
        }
        
        do {
            try soundRecorder = AVAudioRecorder(URL: url, settings: [:] )
        }catch let error as NSError {
            print("Recorder error: \(error.description)")
        }
        
        soundRecorder?.delegate = self
        soundRecorder?.prepareToRecord()
        
        
        
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        
        recordButton.setTitle("Record", forState: UIControlState.Normal)
        
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        
        playButton.setTitle("Play", forState: UIControlState.Normal)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

