//
//  ViewController.swift
//  MoviePlayer
//
//  Created by lemo on 2018/7/3.
//  Copyright © 2018年 wangli. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    var play: PlayManager?
    var slider: UISlider?
    var timer: Timer?
    
    


    
    override func viewDidLoad() {
        super.viewDidLoad()

        addPlayButton()
        addSuspendedButton()
        
//        let file = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
//        let fileName = file! + "/6a0.mp4"
//        localVideoPlay(filePath: fileName)
//        addPlayButton()
        
        play = PlayManager()
        play?.viewController = self
//        play.playVideo(filepath: fileName)
        play?.playVideo(urlString: "http://bos.nj.bpc.baidu.com/tieba-smallvideo/11772_3c435014fb2dd9a5fd56a57cc369f6a0.mp4")
        
        slider = UISlider(frame: CGRect(x: 0, y: 55, width: self.view.frame.width, height: 30))
        slider?.addTarget(self, action: #selector(sliderAction), for: .touchUpInside)
        self.view.addSubview(slider!)
        
        //添加循环,观察视频播放进度
        timer = Timer.init(timeInterval: 1.0, repeats: true) { (timer) in
            let t = self.play?.player?.currentTime()
            let tt = (t?.value)! / Int64((t?.timescale)!)
            print("\(tt)")
            self.slider?.value = Float(tt)
        }
        RunLoop.current.add(timer!, forMode: .commonModes)
        
    }
    
    func addPlayButton() {
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 250, y: 600, width: 100, height: 100)
        button.backgroundColor = .red
        button.setTitle("播放", for: .normal)
        button.addTarget(self, action: #selector(playAction(sender:)), for: .touchUpInside)
        self.view.addSubview(button)
    }
    
    func addSuspendedButton() {
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 150, y: 600, width: 100, height: 100)
        button.backgroundColor = .red
        button.setTitle("暂停", for: .normal)
        button.addTarget(self, action: #selector(suspendedAction(sender:)), for: .touchUpInside)
        self.view.addSubview(button)
    }
    
    @objc func playAction(sender: UIButton) {

        playPlay()
    }
    
    @objc func suspendedAction(sender: UIButton) {
        if sender.currentTitle == "暂停" {
            sender.setTitle("继续", for: .normal)
            play?.player?.pause()
        } else {
            sender.setTitle("暂停", for: .normal)
            play?.player?.play()
        }
    }
    
    func playPlay() {
        if play?.isreadToPlay != nil && (play?.isreadToPlay)! {
            play?.player?.play()
            let timeValue = Float((play?.player?.currentItem?.duration.value)! / Int64((play?.player?.currentItem?.duration.timescale)!))
            
            slider?.maximumValue = timeValue
            
        } else {
            print("视频正在加载...")
        }
    }

    @objc func sliderAction() {
        let seconds = self.slider?.value
        let startTime = CMTimeMakeWithSeconds(Float64(seconds!), (play?.player?.currentItem?.duration.timescale)!)
        play?.player?.seek(to: startTime, completionHandler: { (completion) in
            //完成,重新播放
            self.playPlay()
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    deinit {
        timer?.invalidate()
        timer = nil
    }
}

