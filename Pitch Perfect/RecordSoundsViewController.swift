//
//  RecordSoundsViewController.swift
//  Test
//
//  Created by Dwayne George on 3/5/15.
//  Copyright (c) 2015 Dwayne George. All rights reserved.
//

import UIKit
import AVFoundation



class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
 
    var audioRecorder:AVAudioRecorder! //create global variables
    var recordedAudio:RecordedAudio!
    
    @IBOutlet weak var btnRecord: UIButton!
    
    @IBOutlet weak var labelRecord: UILabel!  //create outlets for buttons
    @IBOutlet weak var btnStop: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        btnStop.hidden = true; //hide stop button until recording has started
        labelRecord.text = "Tap to record" //change text back to
        labelRecord.textColor = UIColor.blackColor() //reset text color
   }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
     }
    
    
    @IBAction func RecordAudio(sender: UIButton) {
        labelRecord.text = "Recording..."           //indicate we are recording
        labelRecord.textColor = UIColor.redColor()
        btnRecord.enabled = false; //disable button to ensure touching it again will not start another recording

        self.labelRecord.alpha = 1.0
        
        //set animation options to fade in and out a recording message
        let options = UIViewAnimationOptions.CurveEaseInOut | UIViewAnimationOptions.Repeat |
            UIViewAnimationOptions.Autoreverse | UIViewAnimationOptions.AllowUserInteraction
        
        //start the animation
        [UIView.animateWithDuration(1.00, delay: 0.0, options: options,
            animations: {self.labelRecord.alpha = 0.0},
            completion: nil)]
        
        btnStop.hidden = false;  //allow stop icon to be displayed
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String //find directory to store information on device
        
        let currentDateTime = NSDate() //create file name
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray) //create entire file path
        println(filePath) //print file path for verification
        
        var session = AVAudioSession.sharedInstance()  //create a session to record file
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil) //create the recorder and give it a file to store the audio
        audioRecorder.delegate = self //indicate that this class is to be called when recording is complete
        audioRecorder.meteringEnabled = true  //turn on level metering
        audioRecorder.record()  //start recording
    
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        
        self.labelRecord.layer.removeAllAnimations() //stop the recording animation
        self.labelRecord.alpha = 100 //make the text visible
        
        //called after recording has finished
        if(flag){  //if the recording was successful
            recordedAudio = RecordedAudio(title: recorder.url.lastPathComponent!, filePathUrl: recorder.url) //create object to store recording info.
            self.performSegueWithIdentifier(("StopRecording"), sender: recordedAudio)  //move to next view
        } else {
            println("Recording was not successful")  //alert user if recording failed
            labelRecord.enabled = true //reset icons on view for recording attempt
            btnStop.hidden = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        btnRecord.enabled = true; //allow more recordings
        //verify that this segue is the result of a recording being stopped
        if(segue.identifier == "StopRecording")
        {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController //create object to play sound
            let data = sender as RecordedAudio //get the audio info
            playSoundsVC.recordedAudio = data //assign audio info to property to be passed
        } else {
            println("Not our segue")
        }
        
    }
    
    @IBAction func StopRecording(sender: UIButton) {
        //stop button pressed
        audioRecorder.stop()  //stop the audio recorder
        var audioSession = AVAudioSession.sharedInstance() //release session
        audioSession.setActive(false, error: nil)
    }


}

