//
//  ViewController.swift
//  HostHark
//
//  Created by Sebastian Sandtorv  on 31/08/15.
//  Copyright (c) 2015 Sebastian Sandtorv . All rights reserved.
//

import Cocoa
import AVFoundation

class ViewController: NSViewController, AVAudioRecorderDelegate {

    var recorder: AVAudioRecorder!
    var meterTimer: NSTimer!
    var soundFileURL:NSURL?
    
    @IBOutlet weak var textLabel: NSTextField!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setupRecorder()
        // Do any additional setup after loading the view.
        textLabel.editable = false
        textLabel.selectable = false
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    func setupRecorder(){
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask,true)[0] as! String
        
        //Name the file with date/time to be unique
        var currentDateTime=NSDate()
        var formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        var recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        var pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        
        
        //Create a new audio recorder
        recorder = AVAudioRecorder(URL: filePath, settings:nil, error:nil)
        recorder.delegate = self
        recorder.meteringEnabled=true
        recorder.prepareToRecord()
        recorder.record()
        meterTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target:self, selector:"updateAudioMeter:", userInfo:nil, repeats:true)
    }
    
    func updateAudioMeter(timer:NSTimer) {
        
        if recorder.recording {
            let min = Int(recorder.currentTime / 60)
            let sec = Int(recorder.currentTime % 60)
            let s = String(format: "%02d:%02d", min, sec)
            recorder.updateMeters()
            // if you want to draw some graphics...
            var apc0 = recorder.averagePowerForChannel(0)
            var peak0 = recorder.peakPowerForChannel(0)
            if(peak0 > 0){
                println("HOST! Etter: \(s)")
                println("Average Power: \(apc0) \nPeak Power: \(peak0)")
                textLabel.stringValue = "Hoster!"
            } else{
                textLabel.stringValue = "Hoster ikke"
            }
        }
    }
    

}

