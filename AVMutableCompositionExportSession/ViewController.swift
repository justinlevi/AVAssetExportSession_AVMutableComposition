//
//  ViewController.swift
//  AVMutableCompositionExportSession
//
//  Created by Justin Winter on 9/28/15.
//  Copyright © 2015 wintercreative. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
  
  var asset: AVAsset?

  @IBAction func exportBtnDidTap(sender: AnyObject) {
    
    guard let asset = asset else {
      return
    }
    
    createAudioFileFromAsset(asset)
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let videoAsset = AVURLAsset(URL: NSBundle.mainBundle().URLForResource("sample", withExtension: "m4v")!)
    let audioAsset1 = AVURLAsset(URL: NSBundle.mainBundle().URLForResource("sample", withExtension: "m4a")!)
    let audioAsset2 = AVURLAsset(URL: NSBundle.mainBundle().URLForResource("audio2", withExtension: "m4a")!)
    
    let comp = AVMutableComposition()
    
    let videoAssetSourceTrack = videoAsset.tracksWithMediaType(AVMediaTypeVideo).first! as AVAssetTrack
    let audioAssetSourceTrack1 = audioAsset1.tracksWithMediaType(AVMediaTypeAudio).first! as AVAssetTrack
    let audioAssetSourceTrack2 = audioAsset2.tracksWithMediaType(AVMediaTypeAudio).first! as AVAssetTrack
    
    let videoCompositionTrack = comp.addMutableTrackWithMediaType(AVMediaTypeVideo, preferredTrackID: kCMPersistentTrackID_Invalid)
    let audioCompositionTrack = comp.addMutableTrackWithMediaType(AVMediaTypeAudio, preferredTrackID: kCMPersistentTrackID_Invalid)
    
    do {
    
//      try videoCompositionTrack.insertTimeRange(
//        CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(10, 600)),
//        ofTrack: videoAssetSourceTrack,
//        atTime: kCMTimeZero)
      
      
      
      try audioCompositionTrack.insertTimeRange(
        CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(7, 600)),
        ofTrack: audioAssetSourceTrack1,
        atTime: kCMTimeZero)
        
      try audioCompositionTrack.insertTimeRange(
        CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(3, 600)),
        ofTrack: audioAssetSourceTrack2,
        atTime: CMTimeMakeWithSeconds(7, 600))
    
    }catch { print(error) }
    
    asset = comp
  }

  func deleteFile(filePath:NSURL) {
    guard NSFileManager.defaultManager().fileExistsAtPath(filePath.path!) else {
      return
    }
    
    do {
      try NSFileManager.defaultManager().removeItemAtPath(filePath.path!)
    }catch{
      fatalError("Unable to delete file: \(error) : \(__FUNCTION__).")
    }
  }
  
  func createAudioFileFromAsset(asset: AVAsset){
    
    let documentsDirectory = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0] as NSURL
    
    let filePath = documentsDirectory.URLByAppendingPathComponent("rendered-audio.m4a")
    deleteFile(filePath)
    
    if let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A){
      
      //    if let supportedTypes = exportSession?.supportedFileTypes {
      //      for str in supportedTypes{
      //        print(str)
      //      }
      //    }
      
      exportSession.canPerformMultiplePassesOverSourceMediaData = true
      exportSession.outputURL = filePath
      exportSession.timeRange = CMTimeRangeMake(kCMTimeZero, asset.duration)
      exportSession.outputFileType = AVFileTypeAppleM4A
      exportSession.exportAsynchronouslyWithCompletionHandler {
        _ in
        print("finished: \(filePath) :  \(exportSession.status.rawValue) ")
      }
    }
    
  }
}

