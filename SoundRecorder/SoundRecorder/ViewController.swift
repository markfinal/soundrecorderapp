//
//  ViewController.swift
//  SoundRecorder
//
//  Created by Mark Final on 04/12/2015.
//  Copyright (c) 2015 Mark Final. All rights reserved.
//

import UIKit
import AVFoundation

// based on the instructions at http://rshankar.com/how-to-record-and-play-sound-in-swift/

class ViewController:
    UIViewController,
    AVAudioRecorderDelegate, // needed to record sounds
    AVAudioPlayerDelegate // needed to play back sounds
{
    let fileName = "demo.caf" // filename of the sound file recorded
    var soundRecorder: AVAudioRecorder! // instance of the recorder object
    var soundPlayer:AVAudioPlayer! // instance of the playback object
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!

    // change the button label to stop, and start recording when pressed
    // vice versa, stop recording, and change button text back to Record when Stop is pressed
    @IBAction func recordSound(sender: UIButton)
    {
        if (sender.titleLabel?.text == "Record")
        {
            soundRecorder.record()
            sender.setTitle("Stop", forState: .Normal)
            playButton.enabled = false
        }
        else
        {
            soundRecorder.stop()
            sender.setTitle("Record", forState: .Normal)
        }
    }

    // change the button label to stop, and start playing when pressed
    // vice versa, stop playback, and change button back to Play when Stop is pressed
    @IBAction func playSound(sender: UIButton)
    {
        if (sender.titleLabel?.text == "Play")
        {
            recordButton.enabled = false
            sender.setTitle("Stop", forState: .Normal)
            preparePlayer()
            soundPlayer.play()
        }
        else
        {
            soundPlayer.stop()
            sender.setTitle("Play", forState: .Normal)
        }
    }

    // get a directory in which to save the sound file
    func getCacheDirectory() -> String
    {
        let paths = NSSearchPathForDirectoriesInDomains(.CachesDirectory,.UserDomainMask, true) as! [String]

        return paths[0]
    }

    // get the URL of the sound file
    func getFileURL() -> NSURL
    {
        let path = getCacheDirectory().stringByAppendingPathComponent(self.fileName)
        let filePath = NSURL(fileURLWithPath: path)

        return filePath!
    }

    // perform all setup required to record the sound file
    func setupRecorder()
    {
        var recordSettings =
        [
            AVFormatIDKey: kAudioFormatAppleLossless,
            AVEncoderAudioQualityKey : AVAudioQuality.Max.rawValue,
            AVEncoderBitRateKey : 320000,
            AVNumberOfChannelsKey: 2,
            AVSampleRateKey : 44100.0
        ]

        var error: NSError?

        self.soundRecorder = AVAudioRecorder(
            URL: getFileURL(),
            settings: recordSettings as [NSObject : AnyObject],
            error: &error)

        if let err = error
        {
            println("AVAudioRecorder error: \(err.localizedDescription)")
        }
        else
        {
            self.soundRecorder.delegate = self
            self.soundRecorder.prepareToRecord()
        }
    }

    // perform all setup required to playback the sound file
    func preparePlayer()
    {
        var error: NSError?

        soundPlayer = AVAudioPlayer(contentsOfURL: getFileURL(), error: &error)

        if let err = error
        {
            println("AVAudioPlayer error: \(err.localizedDescription)")
        }
        else
        {
            soundPlayer.delegate = self
            soundPlayer.prepareToPlay()
            soundPlayer.volume = 1.0
        }
    }

    // callback when sound recording finished
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool)
    {
        playButton.enabled = true
        recordButton.setTitle("Record", forState: .Normal)
    }

    // callback if any error occurred while recording
    func audioRecorderEncodeErrorDidOccur(recorder: AVAudioRecorder!, error: NSError!)
    {
        println("Error while recording audio \(error.localizedDescription)")
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.setupRecorder();
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

