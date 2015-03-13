//
//  PlaySoundsViewController.swift
//  
//
//  Created by Dwayne George on 3/7/15.
//  Copyright (c) 2015 Dwayne George. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var audioPlayer = AVAudioPlayer() //create variable to play audio
    
    var recordedAudio:RecordedAudio! //create variable to record audio
    
    var audioEngine:AVAudioEngine! //create variable to change attributes of audio
    
    var audioFile:AVAudioFile!  //create variable to manage audio file
    
    override func viewDidLoad() {
        super.viewDidLoad()

        audioPlayer = AVAudioPlayer(contentsOfURL: recordedAudio.filePathUrl, error: nil) //initalize player with path to audio file
        audioPlayer.enableRate = true  //allow changing of audio play speed
        audioEngine = AVAudioEngine() //assign AV method
        audioFile = AVAudioFile(forReading: recordedAudio.filePathUrl, error: nil)  //var to hold file path to audio file
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    
    
    func playAudioWithVariablePitch(pitch: Float) {
        audioPlayer.stop()  //prepare to play audio by stopping player and engine
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode() // create audio node and attach to engine
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch() //create AV Unit to change pitch of audio
        changePitchEffect.pitch = pitch  //change pitch to value passed to method
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)  // connect Player Node to Effect
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil) //connect effect to output
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)  //prepare to play file
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play() //play file
    }
    
    
    @IBAction func PlayDarthVader(sender: UIButton) {
        playAudioWithVariablePitch(-1000) //Darth Vader icon touched, modify sound and play
    }
  
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000) //Chipmunk icon touched, modify sound and play
    }
    
    func PlaySound(AudioRate: Float)
    {
        audioEngine.stop() //prepare to play audio by first stopping any existing
        audioPlayer.stop()
        audioPlayer.rate = AudioRate //set the rate to value passed to method
        audioPlayer.prepareToPlay()
        audioPlayer.currentTime = 0.0 //make sure we always start at the begining
        audioPlayer.play() //play now
        
    }
    
    @IBAction func PlaySoundSlow(sender: UIButton) {
        PlaySound( 0.5) //snail icon touched, play sound slow
    }

    @IBAction func PlaySoundFast(sender: UIButton) {
       PlaySound( 02.0) //rabbit icon touched, play sound fast
    }
    
    @IBAction func StopPlay(sender: UIButton) {
        audioPlayer.stop() //stop icon pressed, stop all audio play
        audioEngine.stop()
    }
    

}
